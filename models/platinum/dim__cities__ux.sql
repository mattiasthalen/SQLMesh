/* Type 2 slowly changing dimension table for cities, UX formatted */
MODEL (
  kind VIEW,
  grain city_pit_hk,
  audits (UNIQUE_VALUES(columns := city_pit_hk), NOT_NULL(columns := city_pit_hk))
);

SELECT
  city_pit_id, /* Auto numbered version of the point in time hash key */
  city_hk, /* Surrogate hash key of the city */
  city_pit_hk, /* Point in time hash key of the city */
  city AS "City", /* Name of the city */
  city__latitude AS "City - Latitude", /* Latitude of the city */
  city__longitude AS "City - Longitude", /* Longitude of the city */
  city__source_system AS "City - Source System", /* Source system of the city record */
  city__source_table AS "City - Source Table", /* Source table of the city record */
  city__record_updated_at AS "City - Record Updated At", /* Timestamp when the city record was updated */
  city__record_valid_from AS "City - Record Valid From", /* Timestamp when the city record became valid (inclusive) */
  city__record_valid_to AS "City - Record Valid To" /* Timestamp of when the city record expired (exclusive) */
FROM gold.dim__cities;

@export_to_parquet('platinum.dim__cities__ux', 'exports')