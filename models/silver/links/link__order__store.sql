MODEL (
  name silver.link__order__store,
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := order_hk__store_hk),
    NOT_NULL(columns := (order_hk__store_hk, order_hk, store_hk))
  )
);

SELECT
  order_hk__store_hk,
  order_hk,
  store_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__orders
GROUP BY
  order_hk__store_hk,
  order_hk,
  store_hk,
  source_system,
  source_table