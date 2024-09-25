MODEL (
  name silver.link__order__product,
  kind VIEW
);

SELECT
  order_hk__product_hk,
  order_hk,
  product_hk,
  source,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__items
GROUP BY
  order_hk__product_hk,
  order_hk,
  product_hk,
  source