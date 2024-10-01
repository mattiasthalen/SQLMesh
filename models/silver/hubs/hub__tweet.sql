MODEL (
  name silver.hub__tweet,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := tweet_hk), NOT_NULL(columns := tweet_hk))
);

@data_vault__load_hub(
  sources := silver.stg__jaffle_shop__tweets,
  business_key := tweet_bk,
  hash_key := tweet_hk,
  source_system := source_system,
  source_table := source_table,
  valid_from := cdc_valid_from
)