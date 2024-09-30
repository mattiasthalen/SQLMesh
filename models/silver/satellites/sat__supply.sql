MODEL (
  name silver.sat__supply,
  kind FULL,
  audits (UNIQUE_VALUES(columns := supply_pit_hk), NOT_NULL(columns := supply_pit_hk))
);

SELECT
  supply_hk,
  supply_pit_hk,
  id,
  name,
  cost,
  perishable,
  filename,
  source_system,
  source_table,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__supplies