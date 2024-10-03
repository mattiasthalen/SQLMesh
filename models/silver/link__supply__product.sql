MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := supply_hk__product_hk),
    NOT_NULL(columns := (supply_hk__product_hk, supply_hk, product_hk)),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__supply, fk_column := supply_hk, pk_column := supply_hk),
    ASSERT_FK_PK_INTEGRITY(
      target_table := silver.hub__product,
      fk_column := product_hk,
      pk_column := product_hk
    )
  ),
  depends_on (silver.hub__supply, silver.hub__product)
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__supplies,
  link_key := supply_hk__product_hk,
  hash_keys := (supply_hk, product_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)