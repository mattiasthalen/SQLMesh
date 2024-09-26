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
    id::BINARY AS id,
    customer::BINARY AS customer_id,
    ordered_at::TIMESTAMP AS ordered_at,
    store_id::BINARY AS store_id,
    subtotal::INT AS subtotal,
    tax_paid::INT AS tax_paid,
    order_total::INT AS order_total,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, id)::BINARY AS order_hk,
    @generate_surrogate_key__sha_256(source, id, valid_from)::BINARY AS order_pit_hk,
    @generate_surrogate_key__sha_256(source, customer_id)::BINARY AS customer_hk,
    @generate_surrogate_key__sha_256(source, store_id)::BINARY AS store_hk,
    @generate_surrogate_key__sha_256(source, id, store_id)::BINARY AS order_hk__store_hk,
    @generate_surrogate_key__sha_256(source, customer_id, id)::BINARY AS customer_hk__order_hk,
    id AS order_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data