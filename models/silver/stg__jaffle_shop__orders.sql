MODEL (
  kind FULL,
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
), ghost_record AS (
  SELECT
    NULL AS id,
    NULL AS customer_id,
    NULL AS ordered_at,
    NULL AS store_id,
    NULL AS subtotal,
    NULL AS tax_paid,
    NULL AS order_total,
    NULL AS filename,
    @execution_ts AS cdc_updated_at,
    '1970-01-01 00:00:00'::TIMESTAMP AS cdc_valid_from,
    '9999-12-31 23:59:59'::TIMESTAMP AS cdc_valid_to
), union_data AS (
  SELECT
    *
  FROM casted_data
  UNION ALL
  SELECT
    *
  FROM ghost_record
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(id) AS order_hk,
    @generate_surrogate_key__sha_256(id, cdc_valid_from) AS order_pit_hk,
    @generate_surrogate_key__sha_256(customer_id) AS customer_hk,
    @generate_surrogate_key__sha_256(store_id) AS store_hk,
    *
  FROM union_data
)
SELECT
  *
FROM final_data