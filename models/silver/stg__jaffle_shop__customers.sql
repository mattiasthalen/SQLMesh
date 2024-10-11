MODEL (
  kind FULL,
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
), ghost_record AS (
  SELECT
    NULL AS id,
    NULL AS name,
    NULL AS filename,
    @execution_ts AS cdc_updated_at,
    '1970-01-01 00:00:00'::TIMESTAMP AS cdc_valid_from,
    '9999-12-31 23:59:59'::TIMESTAMP AS cdc_valid_to
), union_data AS (
  SELECT
    *
  FROM casted_data
  UNION ALL
  SELECT
    *
  FROM ghost_record
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(id) AS customer_hk,
    @generate_surrogate_key__sha_256(id, cdc_valid_from) AS customer_pit_hk,
    *
  FROM union_data
)
SELECT
  *
FROM final_data