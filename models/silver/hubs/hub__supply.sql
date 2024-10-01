MODEL (
  name silver.hub__supply,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := supply_hk), NOT_NULL(columns := supply_hk))
);

@data_vault__load_hub(
  sources := silver.stg__jaffle_shop__supplies,
  business_key := supply_bk,
  hash_key := supply_hk,
  source_system := source_system,
  source_table := source_table,
  load_date := cdc_valid_from
)