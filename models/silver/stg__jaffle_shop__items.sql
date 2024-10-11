MODEL (
  kind FULL,
  grain item_pit_hk,
  references (order_hk, product_hk, order_hk__product_hk, item_hk),
  audits (UNIQUE_VALUES(columns := item_pit_hk), NOT_NULL(columns := item_pit_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__items
), casted_data AS (
  SELECT
    id::BLOB AS id,
    order_id::BLOB AS order_id,
    sku::TEXT AS sku,
    filename::TEXT AS filename,
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
  ), ghost_record AS ( 
     SELECT
       NULL AS id,
       NULL AS order_id,
       NULL AS sku,
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
    @generate_surrogate_key__sha_256(id) AS item_hk,
    @generate_surrogate_key__sha_256(id, cdc_valid_from) AS item_pit_hk,
    @generate_surrogate_key__sha_256(order_id) AS order_hk,
    @generate_surrogate_key__sha_256(sku) AS product_hk,
    1 AS quantity,
    *
  FROM union_data
)
SELECT * FROM final_data;