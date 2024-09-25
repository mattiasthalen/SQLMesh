MODEL (
  name gold.dim__products,
  cron '@hourly',
  kind FULL,
  grain product_pit_hk
);

SELECT
  *
FROM silver.sat__product;

@IF(
  @runtime_stage = 'evaluating',
  COPY gold.dim__products
  TO 'exports/gold.dim__products.parquet' WITH (
    FORMAT 'parquet',
    COMPRESSION 'ZSTD'
  )
)