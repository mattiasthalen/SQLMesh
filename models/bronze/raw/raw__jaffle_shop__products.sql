MODEL (
  name bronze.raw__jaffle_shop__products,
  cron '*/10 * * * *',
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