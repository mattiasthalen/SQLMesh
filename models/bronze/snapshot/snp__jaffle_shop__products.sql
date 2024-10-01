MODEL (
  name bronze.snp__jaffle_shop__products,
  cron '*/5 * * * *',
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key sku,
    columns *,
    valid_from_name snapshot_valid_from,
    valid_to_name snapshot_valid_to
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (sku, snapshot_valid_from)),
    NOT_NULL(columns := (sku, snapshot_valid_from))
  )
);

SELECT
  @execution_ts AS snapshot_updated_at,
  *
FROM bronze.raw__jaffle_shop__products