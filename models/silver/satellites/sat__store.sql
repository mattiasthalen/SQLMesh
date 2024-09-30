MODEL (
  name silver.sat__store,
  kind FULL,
  audits (UNIQUE_VALUES(columns := store_pit_hk), NOT_NULL(columns := store_pit_hk))
);

SELECT
  store_hk,
  store_pit_hk,
  id,
  name,
  opened_at,
  tax_rate,
  filename,
  source_system,
  source_table,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__stores