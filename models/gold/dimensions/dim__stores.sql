MODEL (
  name gold.dim__stores,
  cron '@hourly',
  kind FULL,
  grain store_pit_hk
);

SELECT
  *
FROM silver.sat__store;

@export_to_parquet('gold.dim__stores', 'exports')