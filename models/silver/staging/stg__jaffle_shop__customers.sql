MODEL (
  name silver.stg__jaffle_shop__customers,
  kind VIEW,
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
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, id)::BLOB AS customer_hk,
    @generate_surrogate_key__sha_256(source, id, valid_from)::BLOB AS customer_pit_hk,
    name AS customer_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data