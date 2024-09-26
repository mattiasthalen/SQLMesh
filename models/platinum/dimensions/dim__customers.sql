/* Type 2 slowly changing dimension table for customers, UX formatted */
MODEL (
  name platinum.dim__customers__ux,
  kind VIEW,
  grain "customer_pit_hk"
);

SELECT
  customer_hk AS "customer_hk", /* Surrogate hash key of the customer */
  customer_pit_hk AS "customer_pit_hk", /* Point in time hash key of the customer */
  customer_id AS "Customer ID", /* Natural key for the customer */
  customer_name AS "Customer", /* Name of the customer */
  customer_filename AS "Customer - Filename", /* Filename of the import */
  customer_record_source AS "Customer - Record Source", /* Source of the customer record */
  customer_record_valid_from AS "Customer - Record Valid From", /* Timestamp when the customer record became valid (inclusive) */
  customer_record_valid_to AS "Customer - Record Valid To" /* Timestamp of when the customer record expired (exclusive) */
FROM gold.dim__customers;

@export_to_parquet('platinum.dim__customers__ux', 'exports')