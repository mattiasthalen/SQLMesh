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
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, sku)::BINARY AS product_hk,
    @generate_surrogate_key__sha_256(source, sku, valid_from)::BINARY AS product_pit_hk,
    sku AS product_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data