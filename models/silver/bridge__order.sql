MODEL (
  name silver.bridge__customer__order__store__city__coords,
  cron '@hourly',
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := bridge_hk),
    NOT_NULL(columns := (bridge_hk, customer_hk, order_hk, store_hk, city_hk, coords_hk))
  )
);

SELECT
  @generate_surrogate_key__sha_256(
    hub__customer.customer_hk,
    hub__order.order_hk,
    hub__store.store_hk,
    hub__city.city_hk,
    hub__coords.coords_hk,
    hub__product.product_hk
  ) AS bridge_hk,
  hub__customer.customer_hk,
  hub__order.order_hk,
  hub__store.store_hk,
  hub__city.city_hk,
  hub__coords.coords_hk,
  hub__product.product_hk,
  link__customer__order.customer_hk__order_hk,
  link__order__store.order_hk__store_hk,
  link__store__city.store_hk__city_hk,
  link__city__coords.city_hk__coords_hk,
  link__customer__order.customer_hk__order_hk,
  link__order__product.order_hk__product_hk
FROM silver.hub__customer
INNER JOIN silver.link__customer__order
  ON hub__customer.customer_hk = link__customer__order.customer_hk
INNER JOIN silver.hub__order
  ON hub__order.order_hk = link__customer__order.order_hk
INNER JOIN silver.link__order__store
  ON hub__order.order_hk = link__order__store.order_hk
INNER JOIN silver.hub__store
  ON hub__store.store_hk = link__order__store.store_hk
INNER JOIN silver.link__store__city
  ON hub__store.store_hk = link__store__city.store_hk
INNER JOIN silver.hub__city
  ON link__store__city.city_hk = hub__city.city_hk
INNER JOIN silver.link__city__coords
  ON hub__city.city_hk = link__city__coords.city_hk
INNER JOIN silver.hub__coords
  ON link__city__coords.coords_hk = hub__coords.coords_hk
INNER JOIN silver.link__order__product
ON hub__order.order_hk = link__order__product.order_hk
INNER JOIN silver.hub__product
ON link__order__product.product_hk = hub__product.product_hk