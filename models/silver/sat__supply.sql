MODEL (
  kind FULL,
  audits (UNIQUE_VALUES(columns := supply_pit_hk), NOT_NULL(columns := supply_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__supplies,
  hash_key := supply_hk,
  pit_key := supply_pit_hk,
  payload := (id, name, cost, perishable, filename),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)