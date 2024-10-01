MODEL (
  name bronze.snp__jaffle_shop__supplies,
  cron '*/5 * * * *',
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key id,
    columns *,
    valid_from_name cdc_valid_from,
    valid_to_name cdc_valid_to
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (id, cdc_valid_from)),
    NOT_NULL(columns := (id, cdc_valid_from))
  )
);

SELECT
  @execution_ts AS cdc_updated_at,
  *
FROM bronze.raw__jaffle_shop__supplies