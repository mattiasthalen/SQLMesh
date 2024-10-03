MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (UNIQUE_VALUES(columns := order_bk), NOT_NULL(columns := order_bk))
);

@data_vault__load_hub(
  sources := (silver.stg__jaffle_shop__orders, silver.stg__jaffle_shop__items),
  business_key := order_bk,
  hash_key := order_hk,
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)