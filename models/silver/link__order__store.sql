MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := order_hk__store_hk),
    NOT_NULL(columns := (order_hk__store_hk, order_hk, store_hk)),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__order, fk_column := order_hk, pk_column := order_hk),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__store, fk_column := store_hk, pk_column := store_hk)
  ),
  depends_on (silver.hub__order, silver.hub__store)
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__orders,
  link_key := order_hk__store_hk,
  hash_keys := (order_hk, store_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)