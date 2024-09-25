MODEL (
  name gold.dim__customers,
  cron '@hourly',
  kind FULL,
  grain customer_pit_hk
);

SELECT
  *
FROM silver.sat__customer;

@export_to_parquet('gold.dim__customers', 'exports')