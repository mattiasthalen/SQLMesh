MODEL (
  name silver.sat__order,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := order_pit_hk), NOT_NULL(columns := order_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__orders,
  hash_key := order_hk,
  pit_key := order_pit_hk,
  payload := (id, ordered_at, subtotal, tax_paid, order_total, filename),
  source_system := source_system,
  source_table := source_table,
  load_date := cdc_valid_from,
  load_end_date := cdc_valid_to
)