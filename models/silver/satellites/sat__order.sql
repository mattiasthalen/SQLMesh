MODEL (
  name silver.sat__order,
  kind VIEW
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