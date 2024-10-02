MODEL (
  cron '@hourly',
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := bridge_hk),
    NOT_NULL(columns := (bridge_hk, customer_hk, order_hk, product_hk))
  )
);

SELECT
  @generate_surrogate_key__sha_256(
    hub__customer.customer_hk,
    hub__order.order_hk,
    hub__product.product_hk,
    link__customer__order.customer_hk__order_hk,
    link__order__product.order_hk__product_hk
  ) AS bridge_hk,
  hub__customer.customer_hk,
  hub__order.order_hk,
  hub__product.product_hk,
  link__customer__order.customer_hk__order_hk,
  link__order__product.order_hk__product_hk
FROM silver.hub__customer
INNER JOIN silver.link__customer__order
  ON hub__customer.customer_hk = link__customer__order.customer_hk
INNER JOIN silver.hub__order
  ON hub__order.order_hk = link__customer__order.order_hk
INNER JOIN silver.link__order__product
  ON hub__order.order_hk = link__order__product.order_hk
INNER JOIN silver.hub__product
  ON link__order__product.product_hk = hub__product.product_hk