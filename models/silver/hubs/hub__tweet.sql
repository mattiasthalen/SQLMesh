MODEL (
  name silver.hub__tweet,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := tweet_hk), NOT_NULL(columns := tweet_hk))
);

SELECT
  tweet_hk,
  tweet_bk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__tweets
GROUP BY
  tweet_hk,
  tweet_bk,
  source_system,
  source_table