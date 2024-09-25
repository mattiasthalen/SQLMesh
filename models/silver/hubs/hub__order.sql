MODEL (
  name silver.hub__order,
  kind VIEW
);

SELECT
  order_hk,
  order_bk,
  source,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__orders
GROUP BY
  order_hk,
  order_bk,
  source