MODEL (
  name gold.dim__customers,
  cron '@hourly',
  kind FULL,
  grain customer_pit_hk
);

SELECT
  *
FROM silver.sat__customer;

@IF(
  @runtime_stage = 'evaluating',
  COPY gold.dim__customers
  TO 'exports/gold.dim__customers.parquet' WITH (
    format parquet
  )
)