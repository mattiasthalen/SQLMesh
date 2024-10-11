MODEL (
  kind FULL,
  grain city_pit_hk,
  references (city_hk__coords_hk, city_hk, coords_hk),
  audits (UNIQUE_VALUES(columns := city_pit_hk), NOT_NULL(columns := city_pit_hk))
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
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
  ), ghost_record AS ( 
     SELECT
       NULL AS city,
       NULL AS latitude,
       NULL AS longitude,
       @execution_ts AS cdc_updated_at,
       '1970-01-01 00:00:00'::TIMESTAMP AS cdc_valid_from,
       '9999-12-31 23:59:59'::TIMESTAMP AS cdc_valid_to
  ), union_data AS (
      SELECT * FROM casted_data
      UNION ALL
      SELECT * FROM ghost_record
  ), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(city) AS city_hk,
    @generate_surrogate_key__sha_256(city, cdc_valid_from) AS city_pit_hk,
    @generate_surrogate_key__sha_256(latitude, longitude) AS coords_hk,
    *
  FROM union_data
)
SELECT * FROM final_data;