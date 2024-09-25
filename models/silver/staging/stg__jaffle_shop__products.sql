MODEL (
  name silver.stg__jaffle_shop__products,
  kind VIEW
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__products
), casted_data AS (
  SELECT
    sku::TEXT AS sku,
    name::TEXT AS name,
    type::TEXT AS type,
    price::INT AS price,
    description::TEXT AS description,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(sku)::BLOB AS product_hk,
    @generate_surrogate_key__sha_256(sku, valid_from)::BLOB AS product_pit_hk,
    sku AS product_bk,
    'jaffle shop' AS source,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data