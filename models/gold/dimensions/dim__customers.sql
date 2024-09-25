/* Type 2 slowly changing dimension table for customers */
MODEL (
  name gold.dim__customers,
  cron '@hourly',
  kind FULL,
  grain customer_pit_hk
);

SELECT
  customer_hk, /* Surrogate hash key of the customer */
  customer_pit_hk, /* Point in time hash key of the customer */
  source AS customer_record_source, /* Source of the customer record */
  id AS customer_id, /* Natural key for the customer */
  name AS customer_name, /* Name of the customer */
  filename AS customer_filename, /* Filename of the import */
  valid_from AS customer_record_valid_from, /* Timestamp when the customer record became valid (inclusive) */
  valid_to AS customer_record_valid_to /* Timestamp of when the customer record expired (exclusive) */
FROM silver.sat__customer;

@export_to_parquet('gold.dim__customers', 'exports')