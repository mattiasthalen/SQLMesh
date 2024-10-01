MODEL (
  name silver.sat__store,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := store_pit_hk), NOT_NULL(columns := store_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__stores,
  hash_key := store_hk,
  pit_key := store_pit_hk,
  payload := (id, name, opened_at, tax_rate, filename),
  source_system := source_system,
  source_table := source_table,
  load_date := snapshot_valid_from,
  load_end_date := snapshot_valid_to
)