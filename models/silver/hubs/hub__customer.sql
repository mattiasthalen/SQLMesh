MODEL (
  name silver.hub__customer,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := customer_hk), NOT_NULL(columns := customer_hk))
);

SELECT
  customer_hk,
  customer_bk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__customers
GROUP BY
  customer_hk,
  customer_bk,
  source_system,
  source_table