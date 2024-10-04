MODEL (
  cron '*/10 * * * *',
  end '2024-08-29 23:59:59',
  kind VIEW,
  columns (
    id TEXT,
    order_id TEXT,
    sku TEXT,
    filename TEXT
  ),
  audits (NOT_NULL(columns := id), UNIQUE_VALUES(columns := id))
);

SELECT
  id,
  order_id,
  sku,
  filename
FROM READ_CSV('./jaffle-data/raw_items.csv', all_varchar = TRUE, filename = TRUE)