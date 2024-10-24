MODEL (
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
  updated_at := cdc_updated_at
)