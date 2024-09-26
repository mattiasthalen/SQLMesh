/* Type 2 slowly changing dimension table for stores */
MODEL (
  name gold.dim__stores,
  cron '@hourly',
  kind FULL,
  grain store_pit_hk
);

SELECT
  store_hk, /* Surrogate hash key of the store */
  store_pit_hk, /* Point in time hash key of the store */
  id AS store_id, /* Natueral key of the store */
  name AS store, /* Name of the store */
  opened_at AS store__opened_at, /* Timestamp of when the store opened */
  tax_rate AS store__tax_rate, /* Tax rate for the store */
  filename AS store__filename, /* Filename of the import */
  source AS store__record_source, /* Source of the store record */
  valid_from AS store__record_valid_from, /* Timestamp when the store record became valid (inclusive) */
  valid_to AS store__record_valid_to /* Timestamp of when the store record expired (exclusive) */
FROM silver.sat__store;

@export_to_parquet('gold.dim__stores', 'exports')