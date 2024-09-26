MODEL (
  name silver.stg__jaffle_shop__orders,
  kind VIEW,
  grain order_pit_hk,
  references (order_hk, customer_hk, store_hk, order_hk__store_hk, customer_hk__order_hk),
  audits (UNIQUE_VALUES(columns := order_pit_hk), NOT_NULL(columns := order_pit_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__orders
), casted_data AS (
  SELECT
    id::BLOB AS id,
    customer::BLOB AS customer_id,
    ordered_at::TIMESTAMP AS ordered_at,
    store_id::BLOB AS store_id,
    subtotal::INT AS subtotal,
    tax_paid::INT AS tax_paid,
    order_total::INT AS order_total,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_orders' AS source_table,
    @generate_surrogate_key__sha_256(source_system, id)::BLOB AS order_hk,
    @generate_surrogate_key__sha_256(source_system, id, valid_from)::BLOB AS order_pit_hk,
    @generate_surrogate_key__sha_256(source_system, customer_id)::BLOB AS customer_hk,
    @generate_surrogate_key__sha_256(source_system, store_id)::BLOB AS store_hk,
    @generate_surrogate_key__sha_256(source_system, id, store_id)::BLOB AS order_hk__store_hk,
    @generate_surrogate_key__sha_256(source_system, customer_id, id)::BLOB AS customer_hk__order_hk,
    id AS order_bk,
    customer_id AS customer_bk,
    store_id AS store_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data