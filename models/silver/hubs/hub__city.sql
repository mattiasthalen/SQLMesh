MODEL (
  name silver.hub__city,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := city_hk), NOT_NULL(columns := city_hk))
);

@data_vault__load_hub(
  sources := (silver.stg__seed__cities, silver.stg__jaffle_shop__stores),
  business_key := city_bk,
  hash_key := city_hk,
  source_system := source_system,
  source_table := source_table,
  load_date := cdc_valid_from
)