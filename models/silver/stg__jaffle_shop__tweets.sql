MODEL (
  kind FULL,
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
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
  ), ghost_record AS ( 
     SELECT
       NULL AS id,
       NULL AS user_id,
       NULL AS tweeted_at,
       NULL AS content,
       NULL AS filename,
       @execution_ts AS cdc_updated_at,
       '1970-01-01 00:00:00'::TIMESTAMP AS cdc_valid_from,
       '9999-12-31 23:59:59'::TIMESTAMP AS cdc_valid_to
  ), union_data AS (
      SELECT * FROM casted_data
      UNION ALL
      SELECT * FROM ghost_record
  ), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(id) AS tweet_hk,
    @generate_surrogate_key__sha_256(id, cdc_valid_from) AS tweet_pit_hk,
    @generate_surrogate_key__sha_256(user_id) AS tweeter_hk,
    *
  FROM union_data
)
SELECT * FROM final_data;