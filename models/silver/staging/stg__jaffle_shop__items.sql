MODEL (
  name silver.stg__jaffle_shop__items,
  kind VIEW
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__items
), casted_data AS (
  SELECT
    id::UUID AS id,
    order_id::UUID AS order_id,
    sku::TEXT AS sku,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(id)::BLOB AS item_hk,
    @generate_surrogate_key__sha_256(id, valid_from)::BLOB AS item_pit_hk,
    @generate_surrogate_key__sha_256(order_id)::BLOB AS order_hk,
    @generate_surrogate_key__sha_256(sku)::BLOB AS product_hk,
    @generate_surrogate_key__sha_256(order_id, sku)::BLOB AS order_hk__product_hk,
    'jaffle shop' AS source,
    1 AS quantity,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data