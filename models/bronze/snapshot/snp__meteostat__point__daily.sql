MODEL (
  name bronze.snp__meteostat__point__daily,
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key (latitude, longitude, date),
    columns *
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (latitude, longitude, date, valid_from)),
    NOT_NULL(columns := (latitude, longitude, date, valid_from))
  )
);

SELECT
  *
FROM bronze.raw__meteostat__point__daily