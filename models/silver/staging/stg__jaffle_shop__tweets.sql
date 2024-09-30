MODEL (
  name silver.stg__jaffle_shop__tweets,
  kind VIEW,
  grain tweet_pit_hk,
  references (tweeter_hk__tweet_hk, tweeter_hk, tweet_hk),
  audits (UNIQUE_VALUES(columns := tweet_pit_hk), NOT_NULL(columns := tweet_pit_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__tweets
), casted_data AS (
  SELECT
    id::BLOB AS id,
    user_id::BLOB AS user_id,
    tweeted_at::TIMESTAMP AS tweeted_at,
    content::TEXT AS content,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_tweets' AS source_table,
    CONCAT(source_system, '|', id) AS tweet_bk,
    CONCAT(source_system, '|', user_id) AS tweeter_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(tweeter_bk)::BLOB AS tweeter_hk,
    @generate_surrogate_key__sha_256(tweet_bk)::BLOB AS tweet_hk,
    @generate_surrogate_key__sha_256(tweet_bk, valid_from)::BLOB AS tweet_pit_hk,
    @generate_surrogate_key__sha_256(tweeter_bk, tweet_bk)::BLOB AS tweeter_hk__tweet_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data