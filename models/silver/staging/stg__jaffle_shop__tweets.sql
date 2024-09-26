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
    id::BLOB AS id,
    user_id::BLOB AS user_id,
    tweeted_at::TIMESTAMP AS tweeted_at,
    content::TEXT AS content,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, user_id)::BLOB AS tweeter_hk,
    @generate_surrogate_key__sha_256(source, id)::BLOB AS tweet_hk,
    @generate_surrogate_key__sha_256(source, id, valid_from)::BLOB AS tweet_pit_hk,
    @generate_surrogate_key__sha_256(source, user_id, id)::BLOB AS tweeter_hk__tweet_hk,
    user_id AS tweeter_bk,
    id AS tweet_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data