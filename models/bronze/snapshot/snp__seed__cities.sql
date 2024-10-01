MODEL (
  name bronze.snp__seed__cities,
  kind SCD_TYPE_2_BY_COLUMN (
    unique_key city,
    columns *,
    valid_from_name snapshot_valid_from,
    valid_to_name snapshot_valid_to
  ),
  audits (
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (city, snapshot_valid_from)),
    NOT_NULL(columns := (city, snapshot_valid_from))
  )
);

SELECT
  @execution_ts AS snapshot_updated_at,
  *
FROM bronze.raw__seed__cities