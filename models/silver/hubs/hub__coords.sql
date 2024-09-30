MODEL (
  name silver.hub__coords,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := coords_hk), NOT_NULL(columns := coords_hk))
);

@data_vault__load_hub(
  sources := (silver.stg__seed__cities, silver.stg__meteostat__point__daily),
  business_key := coords_bk,
  hash_key := coords_hk,
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from
)