/* Type 2 slowly changing dimension table for products, UX formatted */
MODEL (
  name platinum.dim__products__ux,
  kind VIEW,
  grain "product_pit_hk"
);

SELECT
  product_hk AS "product_hk", /* Surrogate hash key of the product */
  product_pit_hk AS "product_pit_hk", /* Point in time hash key of the product */
  product_id AS "Product ID", /* Natural key of the product */
  product_name AS "Product", /* Name of the product */
  product_type AS "Product - Type", /* Type of product */
  product_price AS "Product - Unit Price", /* Unit price of the product */
  product_description AS "Product - Description", /* Description of the product */
  product_filename AS "Product - Filename", /* Filename of the import */
  product_record_source AS "Product - Record Source", /* Source of the product record */
  product_record_valid_from AS "Product - Record Valid From", /* Timestamp when the product record became valid (inclusive) */
  product_record_valid_to AS "Product - Record Valid To" /* Timestamp of when the product record expired (exclusive) */
FROM gold.dim__products;

@export_to_parquet('platinum.dim__products__ux', 'exports')