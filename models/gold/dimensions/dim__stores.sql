MODEL (
  name gold.dim__stores,
  cron '@hourly',
  kind FULL,
  grain store_pit_hk
);

SELECT
  *
FROM silver.sat__store;

@IF(
  @runtime_stage = 'evaluating',
  COPY gold.dim__stores
  TO 'exports/gold.dim__stores.parquet' WITH (
    format parquet
  )
)