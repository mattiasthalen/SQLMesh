MODEL (
  kind VIEW,
  grain product_pit_hk,
  references product_hk,
  audits (UNIQUE_VALUES(columns := product_pit_hk), NOT_NULL(columns := product_pit_hk))
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
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_products' AS source_table,
    CONCAT(source_system, '|', sku) AS product_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(product_bk) AS product_hk,
    @generate_surrogate_key__sha_256(product_bk, cdc_valid_from) AS product_pit_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data