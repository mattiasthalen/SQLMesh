/* Type 2 slowly changing dimension table for customers */
MODEL (
  name gold.dim__customers,
  cron '@hourly',
  kind FULL,
  grain customer_pit_hk,
  audits (UNIQUE_VALUES(columns := customer_pit_hk), NOT_NULL(columns := customer_pit_hk))
);

SELECT
  customer_hk, /* Surrogate hash key of the customer */
  customer_pit_hk, /* Point in time hash key of the customer */
  id AS customer_id, /* Natural key for the customer */
  name AS customer, /* Name of the customer */
  filename AS customer__filename, /* Filename of the import */
  source_system AS customer__source_system, /* Source system of the customer record */
  source_table AS customer__source_table, /* Source table of the customer record */
  cdc_valid_from AS customer__record_valid_from, /* Timestamp when the customer record became valid (inclusive) */
  cdc_valid_to AS customer__record_valid_to /* Timestamp of when the customer record expired (exclusive) */
FROM silver.sat__customer;

@export_to_parquet('gold.dim__customers', 'exports')