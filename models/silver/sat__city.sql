MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := city_pit_hk),
    NOT_NULL(columns := city_pit_hk),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__city, fk_column := city_hk, pk_column := city_hk)
  ),
  depends_on [silver.hub__city]
);

@data_vault__load_satellite(
  source := silver.stg__seed__cities,
  hash_key := city_hk,
  pit_key := city_pit_hk,
  payload := (city, latitude, longitude),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)