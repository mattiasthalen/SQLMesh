MODEL (
  name silver.hub__tweet,
  kind VIEW
);

SELECT
  tweet_hk,
  tweet_bk,
  source,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__tweets
GROUP BY
  tweet_hk,
  tweet_bk,
  source