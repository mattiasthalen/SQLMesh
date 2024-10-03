MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (UNIQUE_VALUES(columns := city_bk), NOT_NULL(columns := city_bk))
);

@data_vault__load_hub(
  sources := (silver.stg__seed__cities, silver.stg__jaffle_shop__stores),
  business_key := 'city_bk',
  hash_key := 'city_hk',
  source_system := 'source_system',
  source_table := 'source_table',
  updated_at := 'cdc_updated_at'
)