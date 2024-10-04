MODEL (
  cron '*/10 * * * *',
  end '2024-08-29 23:59:59',
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