MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (UNIQUE_VALUES(columns := store_pit_hk), NOT_NULL(columns := store_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__stores,
  hash_key := store_hk,
  pit_key := store_pit_hk,
  payload := (id, name, opened_at, tax_rate, filename),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)