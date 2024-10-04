MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := tweet_pit_hk),
    NOT_NULL(columns := tweet_pit_hk),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__tweet, fk_column := tweet_hk, pk_column := tweet_hk)
  ),
  depends_on [silver.hub__tweet]
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