MODEL (
  name silver.stg__jaffle_shop__tweets,
  kind VIEW
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__tweets
), casted_data AS (
  SELECT
    id::UUID AS id,
    user_id::UUID AS user_id,
    tweeted_at::TIMESTAMP AS tweeted_at,
    content::TEXT AS content,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(user_id)::BLOB AS tweeter_hk,
    @generate_surrogate_key__sha_256(id)::BLOB AS tweet_hk,
    @generate_surrogate_key__sha_256(id, valid_from)::BLOB AS tweet_pit_hk,
    @generate_surrogate_key__sha_256(user_id, id)::BLOB AS tweeter_hk__tweet_hk,
    user_id AS tweeter_bk,
    id AS tweet_bk,
    'jaffle shop' AS source,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data