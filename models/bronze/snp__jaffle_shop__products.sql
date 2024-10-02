MODEL (
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key sku,
    columns *,
    valid_from_name cdc_valid_from,
    valid_to_name cdc_valid_to
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (sku, cdc_valid_from)),
    NOT_NULL(columns := (sku, cdc_valid_from))
  )
);

SELECT
  @execution_ts AS cdc_updated_at,
  *
FROM bronze.raw__jaffle_shop__products