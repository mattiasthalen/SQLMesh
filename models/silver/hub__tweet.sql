MODEL (
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (UNIQUE_VALUES(columns := tweet_bk), NOT_NULL(columns := tweet_bk))
);

@data_vault__load_hub(
  sources := silver.stg__jaffle_shop__tweets,
  business_key := 'tweet_bk',
  hash_key := 'tweet_hk',
  source_system := 'source_system',
  source_table := 'source_table',
  updated_at := 'cdc_updated_at'
)