/* Type 2 slowly changing dimension table for customers */
MODEL (
  name platinum.dim__city__ux,
  kind VIEW,
  grain city_pit_hk,
  audits (UNIQUE_VALUES(columns := city_pit_hk), NOT_NULL(columns := city_pit_hk))
);

SELECT
  city_hk, /* Surrogate hash key of the city */
  city_pit_hk, /* Point in time hash key of the city */
  city AS "City", /* Name of the city */
  city__latitude AS "City - Latitude", /* Latitude of the city */
  city__longitude AS "City - Longitude", /* Longitude of the city */
  city__source_system AS "City - Source System", /* Source system of the customer record */
  city__source_table AS "City - Source Table", /* Source table of the customer record */
  city__record_valid_from AS "City - Valid From", /* Timestamp when the customer record became valid (inclusive) */
  city__record_valid_to AS "City - Valid To" /* Timestamp of when the customer record expired (exclusive) */
FROM gold.dim__city;

@export_to_parquet('platinum.dim__city__ux', 'exports')