MODEL (
  name silver.sat__product,
  kind VIEW
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
  source,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__products