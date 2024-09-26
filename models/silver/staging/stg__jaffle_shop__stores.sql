MODEL (
  name silver.stg__jaffle_shop__stores,
  kind VIEW
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__stores
), casted_data AS (
  SELECT
    id::BINARY AS id,
    name::TEXT AS name,
    opened_at::TIMESTAMP AS opened_at,
    tax_rate::DECIMAL(18, 3) AS tax_rate,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, id)::BINARY AS store_hk,
    @generate_surrogate_key__sha_256(source, id, valid_from)::BINARY AS store_pit_hk,
    id AS store_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data