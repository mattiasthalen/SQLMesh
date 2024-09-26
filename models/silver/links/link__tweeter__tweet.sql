MODEL (
  name silver.link__tweeter__tweet,
  kind VIEW,
  audits (
    UNIQUE_VALUES(columns := tweeter_hk__tweet_hk),
    NOT_NULL(columns := (tweeter_hk__tweet_hk, tweeter_hk, tweet_hk))
  )
);

SELECT
  tweeter_hk__tweet_hk,
  tweeter_hk,
  tweet_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__tweets
GROUP BY
  tweeter_hk__tweet_hk,
  tweeter_hk,
  tweet_hk,
  source_system,
  source_table