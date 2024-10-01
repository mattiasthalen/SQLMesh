MODEL (
  name silver.sat__tweet,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := tweet_pit_hk), NOT_NULL(columns := tweet_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__tweets,
  hash_key := tweet_hk,
  pit_key := tweet_pit_hk,
  payload := (tweeted_at, content, filename),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)