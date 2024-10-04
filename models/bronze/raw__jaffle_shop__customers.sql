MODEL (
  cron '*/10 * * * *',
  end '2024-08-29 23:59:59',
  kind VIEW,
  columns (
    id TEXT,
    name TEXT,
    filename TEXT
  ),
  audits (NOT_NULL(columns := id), UNIQUE_VALUES(columns := id))
);

SELECT
  id,
  name,
  filename
FROM READ_CSV('./jaffle-data/raw_customers.csv', all_varchar = TRUE, filename = TRUE)