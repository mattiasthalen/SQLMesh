/* Type 2 slowly changing dimension table for products, UX formatted */
MODEL (
  kind VIEW,
  grain "product_pit_hk",
  audits (UNIQUE_VALUES(columns := product_pit_hk), NOT_NULL(columns := product_pit_hk))
);

SELECT
  product_pit_id, /* Auto numbered version of the point in time hash key */
  product_hk AS "product_hk", /* Surrogate hash key of the product */
  product_pit_hk AS "product_pit_hk", /* Point in time hash key of the product */
  product_id AS "Product ID", /* Natural key of the product */
  product AS "Product", /* Name of the product */
  product__type AS "Product - Type", /* Type of product */
  product__unit_price AS "Product - Unit Price", /* Unit price of the product */
  product__description AS "Product - Description", /* Description of the product */
  product__filename AS "Product - Filename", /* Filename of the import */
  product__source_system AS "Product - Source System", /* Source system of the product record */
  product__source_table AS "Product - Source Table", /* Source table of the product record */
  product__record_updated_at AS "Product - Record Updated At", /* Timestamp when the product record was updated */
  product__record_valid_from AS "Product - Record Valid From", /* Timestamp when the product record became valid (inclusive) */
  product__record_valid_to AS "Product - Record Valid To" /* Timestamp of when the product record expired (exclusive) */
FROM gold.dim__products;