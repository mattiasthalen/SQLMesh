MODEL (
  name silver.link__tweeter__tweet,
  cron '@hourly',
  kind FULL,
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
  load_date := snapshot_valid_from,
  load_end_date := snapshot_valid_to
)