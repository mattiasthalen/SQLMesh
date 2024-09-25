MODEL (
  name silver.stg__jaffle_shop__orders,
  kind VIEW
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__orders
), casted_data AS (
  SELECT
    id::UUID AS id,
    customer::UUID AS customer_id,
    ordered_at::TIMESTAMP AS ordered_at,
    store_id::UUID AS store_id,
    subtotal::INT AS subtotal,
    tax_paid::INT AS tax_paid,
    order_total::INT AS order_total,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(id)::BLOB AS order_hk,
    @generate_surrogate_key__sha_256(id, valid_from)::BLOB AS order_pit_hk,
    @generate_surrogate_key__sha_256(customer_id)::BLOB AS customer_hk,
    @generate_surrogate_key__sha_256(store_id)::BLOB AS store_hk,
    @generate_surrogate_key__sha_256(id, store_id)::BLOB AS order_hk__store_hk,
    @generate_surrogate_key__sha_256(customer_id, id)::BLOB AS customer_hk__order_hk,
    id AS order_bk,
    'jaffle shop' AS source,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data