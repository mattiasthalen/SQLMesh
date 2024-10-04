MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := city_hk__coords_hk),
    NOT_NULL(columns := (city_hk__coords_hk, city_hk, coords_hk)),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__city, fk_column := city_hk, pk_column := city_hk),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__coords, fk_column := coords_hk, pk_column := coords_hk)
  ),
  depends_on [silver.hub__city, silver.hub__coords]
);

@data_vault__load_link(
  sources := silver.stg__seed__cities,
  link_key := city_hk__coords_hk,
  hash_keys := (city_hk, coords_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)