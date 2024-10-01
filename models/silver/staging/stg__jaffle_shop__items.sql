MODEL (
  name silver.stg__jaffle_shop__items,
  kind VIEW,
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
    snapshot_updated_at::TIMESTAMP AS snapshot_updated_at,
    snapshot_valid_from::TIMESTAMP AS snapshot_valid_from,
    COALESCE(snapshot_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS snapshot_valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_items' AS source_table,
    CONCAT(source_system, '|', id) AS item_bk,
    CONCAT(source_system, '|', order_id) AS order_bk,
    CONCAT(source_system, '|', sku) AS product_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(item_bk) AS item_hk,
    @generate_surrogate_key__sha_256(item_bk, snapshot_valid_from) AS item_pit_hk,
    @generate_surrogate_key__sha_256(order_bk) AS order_hk,
    @generate_surrogate_key__sha_256(product_bk) AS product_hk,
    @generate_surrogate_key__sha_256(order_bk, product_bk) AS order_hk__product_hk,
    1 AS quantity,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data