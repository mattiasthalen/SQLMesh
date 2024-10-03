MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (UNIQUE_VALUES(columns := coords_bk), NOT_NULL(columns := coords_bk))
);

@data_vault__load_hub(
  sources := (silver.stg__seed__cities, silver.stg__meteostat__point__daily),
  business_key := coords_bk,
  hash_key := coords_hk,
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)