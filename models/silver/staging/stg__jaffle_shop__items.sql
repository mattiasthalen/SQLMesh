MODEL (
  name silver.stg__jaffle_shop__items,
  kind VIEW,
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
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, id)::BLOB AS item_hk,
    @generate_surrogate_key__sha_256(source, id, valid_from)::BLOB AS item_pit_hk,
    @generate_surrogate_key__sha_256(source, order_id)::BLOB AS order_hk,
    @generate_surrogate_key__sha_256(source, sku)::BLOB AS product_hk,
    @generate_surrogate_key__sha_256(source, order_id, sku)::BLOB AS order_hk__product_hk,
    1 AS quantity,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data