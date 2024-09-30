MODEL (
  name bronze.snp__seed__cities,
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key city,
    columns *
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (city, valid_from)),
    NOT_NULL(columns := (city, valid_from))
  )
);

SELECT
  *
FROM bronze.raw__seed__cities