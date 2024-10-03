MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := tweeter_hk__tweet_hk),
    NOT_NULL(columns := (tweeter_hk__tweet_hk, tweeter_hk, tweet_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__tweets,
  link_key := tweeter_hk__tweet_hk,
  hash_keys := (tweeter_hk, tweet_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)