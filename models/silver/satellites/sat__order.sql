MODEL (
  name silver.sat__order,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := order_pit_hk), NOT_NULL(columns := order_pit_hk))
);

SELECT
  order_hk,
  order_pit_hk,
  id,
  ordered_at,
  subtotal,
  tax_paid,
  order_total,
  filename,
  source,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__orders