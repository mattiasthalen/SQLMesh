MODEL (
  cron '*/10 * * * *',
  end '2024-08-29 23:59:59',
  kind VIEW,
  columns (
    sku TEXT,
    name TEXT,
    type TEXT,
    price TEXT,
    description TEXT,
    filename TEXT
  ),
  audits (NOT_NULL(columns := sku), UNIQUE_VALUES(columns := sku))
);

SELECT
  sku,
  name,
  type,
  price,
  description,
  filename
FROM READ_CSV('./jaffle-data/raw_products.csv', all_varchar = TRUE, filename = TRUE)