MODEL (
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := product_pit_hk), NOT_NULL(columns := product_pit_hk))
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