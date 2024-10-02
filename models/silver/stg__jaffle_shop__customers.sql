MODEL (
  kind VIEW,
  grain customer_pit_hk,
  references customer_hk,
  audits (UNIQUE_VALUES(columns := customer_pit_hk), NOT_NULL(columns := customer_pit_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__customers
), casted_data AS (
  SELECT
    id::BLOB AS id,
    name::TEXT AS name,
    filename::TEXT AS filename,
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_customers' AS source_table,
    CONCAT(source_system, '|', id) AS customer_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(customer_bk) AS customer_hk,
    @generate_surrogate_key__sha_256(customer_bk, cdc_valid_from) AS customer_pit_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data