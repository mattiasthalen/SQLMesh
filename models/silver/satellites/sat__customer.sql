MODEL (
  name silver.sat__customer,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := customer_pit_hk), NOT_NULL(columns := customer_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__customers,
  hash_key := customer_hk,
  pit_key := customer_pit_hk,
  payload := (id, name, filename),
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from,
  load_end_date := valid_to
)