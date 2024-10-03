MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (UNIQUE_VALUES(columns := supply_bk), NOT_NULL(columns := supply_bk))
);

@data_vault__load_hub(
  sources := silver.stg__jaffle_shop__supplies,
  business_key := 'supply_bk',
  hash_key := 'supply_hk',
  source_system := 'source_system',
  source_table := 'source_table',
  updated_at := 'cdc_updated_at'
)