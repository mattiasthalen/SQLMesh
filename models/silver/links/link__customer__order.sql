MODEL (
  name silver.link__customer__order,
  kind VIEW,
  audits (
    UNIQUE_VALUES(columns := customer_hk__order_hk),
    NOT_NULL(columns := (customer_hk__order_hk, customer_hk, order_hk))
  )
);

SELECT
  customer_hk__order_hk,
  customer_hk,
  order_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__orders
GROUP BY
  customer_hk__order_hk,
  customer_hk,
  order_hk,
  source_system,
  source_table