MODEL (
  name silver.sat__supply,
  kind VIEW
);

SELECT
  supply_hk,
  supply_pit_hk,
  id,
  name,
  cost,
  perishable,
  filename,
  source,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__supplies