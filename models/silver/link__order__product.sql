MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := order_hk__product_hk),
    NOT_NULL(columns := (order_hk__product_hk, order_hk, product_hk)),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__order, fk_column := order_hk, pk_column := order_hk),
    ASSERT_FK_PK_INTEGRITY(
      target_table := silver.hub__product,
      fk_column := product_hk,
      pk_column := product_hk
    )
  ),
  depends_on (silver.hub__order, silver.hub__product)
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__items,
  link_key := order_hk__product_hk,
  hash_keys := (order_hk, product_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)