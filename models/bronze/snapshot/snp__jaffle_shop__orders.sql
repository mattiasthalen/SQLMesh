MODEL (
  name bronze.snp__jaffle_shop__orders,
  cron '*/5 * * * *',
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key id,
    columns *
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (id, valid_from)),
    NOT_NULL(columns := (id, valid_from))
  )
);

SELECT
  *
FROM bronze.raw__jaffle_shop__orders