MODEL (
  name silver.stg__seed__cities,
  kind VIEW,
  grain city_hk,
  references (city_hk__coords_hk, city_hk, coords_hk),
  audits (UNIQUE_VALUES(columns := coords_pit_hk), NOT_NULL(columns := coords_pit_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__seed__cities
), casted_data AS (
  SELECT
    city::TEXT AS city,
    latitude::DECIMAL(18, 3) AS latitude,
    longitude::DECIMAL(18, 3) AS longitude,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'seed' AS source_system,
    'cities' AS source_table,
    @generate_surrogate_key__sha_256(city)::BLOB AS city_hk,
    @generate_surrogate_key__sha_256(city, latitude, longitude)::BLOB AS city_hk__coords_hk,
    @generate_surrogate_key__sha_256(latitude, longitude)::BLOB AS coords_hk,
    @generate_surrogate_key__sha_256(latitude, longitude, valid_from)::BLOB AS coords_pit_hk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data