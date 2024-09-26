MODEL (
  name silver.sat__customer,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := customer_pit_hk), NOT_NULL(columns := customer_pit_hk))
);

SELECT
  customer_hk,
  customer_pit_hk,
  source,
  id,
  name,
  filename,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__customers