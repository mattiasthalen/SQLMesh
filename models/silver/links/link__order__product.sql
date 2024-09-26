MODEL (
  name silver.link__order__product,
  kind VIEW,
  audits (
    UNIQUE_VALUES(columns := order_hk__product_hk),
    NOT_NULL(columns := (order_hk__product_hk, order_hk, product_hk))
  )
);

SELECT
  order_hk__product_hk,
  order_hk,
  product_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__items
GROUP BY
  order_hk__product_hk,
  order_hk,
  product_hk,
  source_system,
  source_table