MODEL (
  name silver.hub__order,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := order_hk), NOT_NULL(columns := order_hk))
);

SELECT
  order_hk,
  order_bk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__orders
GROUP BY
  order_hk,
  order_bk,
  source_system,
  source_table