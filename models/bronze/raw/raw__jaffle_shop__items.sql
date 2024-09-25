MODEL (
  name bronze.raw__jaffle_shop__items,
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