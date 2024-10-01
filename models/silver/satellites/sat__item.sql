MODEL (
  name silver.sat__item,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := item_pit_hk), NOT_NULL(columns := item_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__items,
  hash_key := item_hk,
  pit_key := item_pit_hk,
  payload := (order_hk__product_hk, quantity, filename),
  source_system := source_system,
  source_table := source_table,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)