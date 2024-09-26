MODEL (
  name silver.sat__tweet,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := tweet_pit_hk), NOT_NULL(columns := tweet_pit_hk))
);

SELECT
  tweet_hk,
  tweet_pit_hk,
  tweeted_at,
  content,
  filename,
  source,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__tweets