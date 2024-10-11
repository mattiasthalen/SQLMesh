/* Type 2 slowly changing dimension table for customers */
MODEL (
  kind FULL,
  grain city_pit_hk,
  audits (UNIQUE_VALUES(columns := city_pit_hk), NOT_NULL(columns := city_pit_hk))
);

SELECT
  ROW_NUMBER() OVER () AS city_pit_id, /* Auto numbered version of the point in time hash key */
  city_hk, /* Surrogate hash key of the city */
  city_pit_hk, /* Point in time hash key of the city */
  city, /* Name of the city */
  latitude AS city__latitude, /* Latitude of the city */
  longitude AS city__longitude, /* Longitude of the city */
  source_system AS city__source_system, /* Source system of the customer record */
  source_table AS city__source_table, /* Source table of the customer record */
  cdc_updated_at AS city__record_updated_at, /* Timestamp when the customer record was updated */
  cdc_valid_from AS city__record_valid_from, /* Timestamp when the customer record became valid (inclusive) */
  cdc_valid_to AS city__record_valid_to /* Timestamp of when the customer record expired (exclusive) */
FROM silver.sat__city;

@export_to_parquet('gold.dim__cities', 'exports')