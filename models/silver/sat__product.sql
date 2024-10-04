MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := product_pit_hk),
    NOT_NULL(columns := product_pit_hk),
    ASSERT_FK_PK_INTEGRITY(
      target_table := silver.hub__product,
      fk_column := product_hk,
      pk_column := product_hk
    )
  ),
  depends_on [silver.hub__product]
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__products,
  hash_key := product_hk,
  pit_key := product_pit_hk,
  payload := (sku, name, type, price, description, filename),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)