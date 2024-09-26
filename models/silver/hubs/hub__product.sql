MODEL (
  name silver.hub__product,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := product_hk), NOT_NULL(columns := product_hk))
);

SELECT
  product_hk,
  product_bk,
  source,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__products
GROUP BY
  product_hk,
  product_bk,
  source