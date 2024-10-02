MODEL (
  kind VIEW,
  grain city_hk,
  references (city_hk__coords_hk, coords_hk),
  audits (UNIQUE_VALUES(columns := city_hk), NOT_NULL(columns := city_hk))
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
), data_vault AS (
  SELECT
    'seed' AS source_system,
    'cities' AS source_table,
    city AS city_bk,
    CONCAT(latitude, '|', longitude) AS coords_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(city_bk) AS city_hk,
    @generate_surrogate_key__sha_256(city_bk, cdc_valid_from) AS city_pit_hk,
    @generate_surrogate_key__sha_256(city_bk, coords_bk) AS city_hk__coords_hk,
    @generate_surrogate_key__sha_256(coords_bk) AS coords_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data