MODEL (
  name silver.sat__product,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := product_pit_hk), NOT_NULL(columns := product_pit_hk))
);

SELECT
  product_hk,
  product_pit_hk,
  sku,
  name,
  type,
  price,
  description,
  filename,
  source_system,
  source_table,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__products