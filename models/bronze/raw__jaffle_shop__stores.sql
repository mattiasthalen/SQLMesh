MODEL (
  cron '*/10 * * * *',
  end '2024-08-29 23:59:59',
  kind VIEW,
  columns (
    id TEXT,
    name TEXT,
    opened_at TEXT,
    tax_rate TEXT,
    filename TEXT
  ),
  audits (NOT_NULL(columns := id), UNIQUE_VALUES(columns := id))
);

SELECT
  id,
  name,
  opened_at,
  tax_rate,
  filename
FROM READ_CSV('./jaffle-data/raw_stores.csv', all_varchar = TRUE, filename = TRUE)