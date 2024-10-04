MODEL (
  cron '*/10 * * * *',
  end '2024-08-29 23:59:59',
  kind VIEW,
  columns (
    id TEXT,
    customer TEXT,
    ordered_at TEXT,
    store_id TEXT,
    subtotal TEXT,
    tax_paid TEXT,
    order_total TEXT,
    filename TEXT
  ),
  audits (NOT_NULL(columns := id), UNIQUE_VALUES(columns := id))
);

SELECT
  id,
  customer,
  ordered_at,
  store_id,
  subtotal,
  tax_paid,
  order_total,
  filename
FROM READ_CSV('./jaffle-data/raw_orders.csv', all_varchar = TRUE, filename = TRUE)