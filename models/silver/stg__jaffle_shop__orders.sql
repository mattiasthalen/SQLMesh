MODEL (
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
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_orders' AS source_table,
    CONCAT(source_system, '|', id) AS order_bk,
    CONCAT(source_system, '|', customer_id) AS customer_bk,
    CONCAT(source_system, '|', store_id) AS store_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(order_bk) AS order_hk,
    @generate_surrogate_key__sha_256(order_bk, cdc_valid_from) AS order_pit_hk,
    @generate_surrogate_key__sha_256(customer_bk) AS customer_hk,
    @generate_surrogate_key__sha_256(store_bk) AS store_hk,
    @generate_surrogate_key__sha_256(order_bk, store_bk) AS order_hk__store_hk,
    @generate_surrogate_key__sha_256(customer_bk, order_bk) AS customer_hk__order_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data