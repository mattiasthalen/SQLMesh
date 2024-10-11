MODEL (
  kind FULL,
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
  ), ghost_record AS ( 
     SELECT
        NULL AS sku,
        NULL AS name,
        NULL AS type,
        NULL AS price,
        NULL AS description,
       NULL AS filename,
       @execution_ts AS cdc_updated_at,
       '1970-01-01 00:00:00'::TIMESTAMP AS cdc_valid_from,
       '9999-12-31 23:59:59'::TIMESTAMP AS cdc_valid_to
  ), union_data AS (
      SELECT * FROM casted_data
      UNION ALL
      SELECT * FROM ghost_record
  ), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(sku) AS product_hk,
    @generate_surrogate_key__sha_256(sku, cdc_valid_from) AS product_pit_hk,
    *
  FROM union_data
)
SELECT * FROM final_data;