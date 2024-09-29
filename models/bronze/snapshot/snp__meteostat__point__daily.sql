MODEL (
  name bronze.snp__meteostat__point__daily,
  kind SCD_TYPE_2_BY_TIME (
    unique_key coords_hk,
    updated_at_as_valid_from TRUE
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (latitude, longitude, date, valid_from)),
    NOT_NULL(columns := (latitude, longitude, date, valid_from))
  )
);

SELECT
  @generate_surrogate_key__sha_256(latitude, longitude)::BLOB AS coords_hk,
  date::DATE AS updated_at,
  *
FROM bronze.raw__meteostat__point__daily