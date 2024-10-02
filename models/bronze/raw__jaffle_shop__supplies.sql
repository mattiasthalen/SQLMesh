MODEL (
  name bronze.raw__jaffle_shop__supplies,
  cron '*/10 * * * *',
  kind VIEW,
  columns (
    id TEXT,
    name TEXT,
    cost TEXT,
    perishable TEXT,
    sku TEXT,
    filename TEXT
  ),
  audits (
    NOT_NULL(columns := id),
    NOT_NULL(columns := sku),
    UNIQUE_COMBINATION_OF_COLUMNS(columns := (id, sku))
  )
);

SELECT
  id,
  name,
  cost,
  perishable,
  sku,
  filename
FROM READ_CSV('./jaffle-data/raw_supplies.csv', all_varchar = TRUE, filename = TRUE)