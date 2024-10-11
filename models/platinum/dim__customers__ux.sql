/* Type 2 slowly changing dimension table for customers, UX formatted */
MODEL (
  kind VIEW,
  grain "customer_pit_hk",
  audits (UNIQUE_VALUES(columns := customer_pit_hk), NOT_NULL(columns := customer_pit_hk))
);

SELECT
  customer_pit_id, /* Auto numbered version of the point in time hash key */
  customer_hk AS "customer_hk", /* Surrogate hash key of the customer */
  customer_pit_hk AS "customer_pit_hk", /* Point in time hash key of the customer */
  customer_id AS "Customer ID", /* Natural key for the customer */
  customer AS "Customer", /* Name of the customer */
  customer__filename AS "Customer - Filename", /* Filename of the import */
  customer__record_updated_at AS "Customer - Record Updated At", /* Timestamp when the customer record was updated */
  customer__record_valid_from AS "Customer - Record Valid From", /* Timestamp when the customer record became valid (inclusive) */
  customer__record_valid_to AS "Customer - Record Valid To" /* Timestamp of when the customer record expired (exclusive) */
FROM gold.dim__customers;

@export_to_parquet('platinum.dim__customers__ux', 'exports')