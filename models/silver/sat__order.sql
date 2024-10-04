MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := order_pit_hk),
    NOT_NULL(columns := order_pit_hk),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__order, fk_column := order_hk, pk_column := order_hk)
  ),
  depends_on [silver.hub__order]
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__orders,
  hash_key := order_hk,
  pit_key := order_pit_hk,
  payload := (id, ordered_at, subtotal, tax_paid, order_total, filename),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)