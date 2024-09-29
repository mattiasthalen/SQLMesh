MODEL (
  name silver.stg__meteostat__point__daily,
  kind VIEW,
  grain city_hk,
  references (city_hk__coords_hk, coords_hk),
  audits (UNIQUE_VALUES(columns := city_hk), NOT_NULL(columns := city_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__meteostat__point__daily
), casted_data AS (
  SELECT
    latitude::DECIMAL(18, 3) AS latitude,
    longitude::DECIMAL(18, 3) AS longitude,
    date::DATE AS date,
    tavg::DECIMAL(18, 3) AS tavg,
    tmin::DECIMAL(18, 3) AS tmin,
    tmax::DECIMAL(18, 3) AS tmax,
    prcp::DECIMAL(18, 3) AS prcp,
    snow::DECIMAL(18, 3) AS snow,
    wdir::DECIMAL(18, 3) AS wdir,
    wspd::DECIMAL(18, 3) AS wspd,
    wpgt::DECIMAL(18, 3) AS wpgt,
    pres::DECIMAL(18, 3) AS pres,
    tsun::DECIMAL(18, 3) AS tsun,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    'meteostat' AS source_system,
    'point__daily' AS source_table,
    @generate_surrogate_key__sha_256(latitude, longitude)::BLOB AS coords_hk,
    @generate_surrogate_key__sha_256(latitude, longitude, valid_from)::BLOB AS coords_pit_hk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data