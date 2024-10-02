MODEL (
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := store_hk), NOT_NULL(columns := store_hk))
);

@data_vault__load_hub(
  sources := (silver.stg__jaffle_shop__stores, silver.stg__jaffle_shop__orders),
  business_key := 'store_bk',
  hash_key := 'store_hk',
  source_system := 'source_system',
  source_table := 'source_table',
  updated_at := 'cdc_updated_at'
)