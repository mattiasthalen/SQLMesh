MODEL (
  name gold.dim__products,
  cron '@hourly',
  kind FULL,
  grain product_pit_hk
);

SELECT
  *
FROM silver.sat__product;

@export_to_parquet('gold.dim__products', 'exports')