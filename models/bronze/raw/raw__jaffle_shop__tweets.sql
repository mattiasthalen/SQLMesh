MODEL (
  name bronze.raw__jaffle_shop__tweets,
  cron '*/10 * * * *',
  kind VIEW,
  columns (
    id TEXT,
    user_id TEXT,
    tweeted_at TEXT,
    content TEXT,
    filename TEXT
  ),
  audits (NOT_NULL(columns := id), UNIQUE_VALUES(columns := id))
);

SELECT
  id,
  user_id,
  tweeted_at,
  content,
  filename
FROM READ_CSV('./jaffle-data/raw_tweets.csv', all_varchar = TRUE, filename = TRUE)