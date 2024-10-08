MODEL (
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := supply_bk), NOT_NULL(columns := supply_bk))
);

@data_vault__load_hub(
  sources := silver.stg__jaffle_shop__supplies,
  business_key := supply_bk,
  hash_key := supply_hk,
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)