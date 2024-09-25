MODEL (
  name silver.sat__customer,
  kind VIEW
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