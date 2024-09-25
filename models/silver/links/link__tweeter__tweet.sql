MODEL (
  name silver.link__tweeter__tweet,
  kind VIEW
);

SELECT
  tweeter_hk__tweet_hk,
  tweeter_hk,
  tweet_hk,
  source,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__tweets
GROUP BY
  tweeter_hk__tweet_hk,
  tweeter_hk,
  tweet_hk,
  source