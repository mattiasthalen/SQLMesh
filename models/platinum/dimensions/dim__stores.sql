/* Type 2 slowly changing dimension table for stores, UX formatted */
MODEL (
  name platinum.dim__stores__ux,
  kind VIEW,
  grain "store_pit_hk"
);

SELECT
  store_hk AS "store_hk", /* Surrogate hash key of the store */
  store_pit_hk AS "store_pit_hk", /* Point in time hash key of the store */
  store_id AS "Store ID", /* Natueral key of the store */
  store AS "Store", /* Name of the store */
  store__opened_at AS "Store - Opened At", /* Timestamp of when the store opened */
  store__tax_rate AS "Store - Tax Rate", /* Tax rate for the store */
  store__filename AS "Store - Filename", /* Filename of the import */
  store__record_source AS "Store - Record Source", /* Source of the store record */
  store__record_valid_from AS "Store - Record Valid From", /* Timestamp when the store record became valid (inclusive) */
  store__record_valid_to AS "Store - Record Valid To" /* Timestamp of when the store record expired (exclusive) */
FROM gold.dim__stores;

@export_to_parquet('platinum.dim__stores__ux', 'exports')