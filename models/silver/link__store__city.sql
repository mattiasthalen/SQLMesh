MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := store_hk__city_hk),
    NOT_NULL(columns := (store_hk__city_hk, store_hk, city_hk)),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__store, fk_column := store_hk, pk_column := store_hk),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__city, fk_column := city_hk, pk_column := city_hk)
  ),
  depends_on (silver.hub__store, silver.hub__city)
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__stores,
  link_key := store_hk__city_hk,
  hash_keys := (store_hk, city_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)