MODEL (
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key (latitude, longitude, date),
    columns *,
    valid_from_name cdc_valid_from,
    valid_to_name cdc_valid_to
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (latitude, longitude, date, cdc_valid_from)),
    NOT_NULL(columns := (latitude, longitude, date, cdc_valid_from))
  )
);

SELECT
  @execution_ts::TIMESTAMP AS cdc_updated_at,
  *
FROM bronze.raw__meteostat__point__daily