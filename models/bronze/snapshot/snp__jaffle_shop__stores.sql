MODEL (
  name bronze.snp__jaffle_shop__stores,
  cron '*/5 * * * *',
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key id,
    columns *,
    execution_time_as_valid_from TRUE
  )
);

SELECT
  *
FROM bronze.raw__jaffle_shop__stores