/* Type 2 slowly changing dimension table for products */
MODEL (
  name gold.dim__products,
  cron '@hourly',
  kind FULL,
  grain product_pit_hk
);

SELECT
  product_hk, /* Surrogate hash key of the product */
  product_pit_hk, /* Point in time hash key of the product */
  sku AS product_id, /* Natural key of the product */
  name AS product, /* Name of the product */
  type AS product__type, /* Type of product */
  price AS product__unit_price, /* Unit price of the product */
  description AS product__description, /* Description of the product */
  filename AS product__filename, /* Filename of the import */
  source AS product__record_source, /* Source of the product record */
  valid_from AS product__record_valid_from, /* Timestamp when the product record became valid (inclusive) */
  valid_to AS product__record_valid_to /* Timestamp of when the product record expired (exclusive) */
FROM silver.sat__product;

@export_to_parquet('gold.dim__products', 'exports')