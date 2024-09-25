MODEL (
  name silver.hub__customer,
  kind VIEW
);

SELECT
  customer_hk,
  customer_bk,
  source,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__customers
GROUP BY
  customer_hk,
  customer_bk,
  source