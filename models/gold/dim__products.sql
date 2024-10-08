/* Type 2 slowly changing dimension table for products */
MODEL (
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (product__record_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  grain product_pit_hk,
  audits (UNIQUE_VALUES(columns := product_pit_hk), NOT_NULL(columns := product_pit_hk))
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
  source_system AS product__source_system, /* Source system of the product record */
  source_table AS product__source_table, /* Source table of the product record */
  cdc_updated_at AS product__record_updated_at, /* Timestamp when the product record was updated */
  cdc_valid_from AS product__record_valid_from, /* Timestamp when the product record became valid (inclusive) */
  cdc_valid_to AS product__record_valid_to /* Timestamp of when the product record expired (exclusive) */
FROM silver.sat__product
WHERE
  product__record_updated_at BETWEEN @start_ts AND @end_ts;

@export_to_parquet('gold.dim__products', 'exports')