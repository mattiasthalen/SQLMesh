MODEL (
  name silver.stg__meteostat__point__daily,
  kind VIEW,
  grain city_hk,
  references (
    coords_hk
  ),
  audits (UNIQUE_VALUES(columns := weather_pit_hk), NOT_NULL(columns := weather_pit_hk))
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
    NULLIF(NULLIF(tavg, 'nan'), 'None')::DECIMAL(18, 3) AS tavg,
    NULLIF(NULLIF(tmin, 'nan'), 'None')::DECIMAL(18, 3) AS tmin,
    NULLIF(NULLIF(tmax, 'nan'), 'None')::DECIMAL(18, 3) AS tmax,
    NULLIF(NULLIF(prcp, 'nan'), 'None')::DECIMAL(18, 3) AS prcp,
    NULLIF(NULLIF(snow, 'nan'), 'None')::DECIMAL(18, 3) AS snow,
    NULLIF(NULLIF(wdir, 'nan'), 'None')::DECIMAL(18, 3) AS wdir,
    NULLIF(NULLIF(wspd, 'nan'), 'None')::DECIMAL(18, 3) AS wspd,
    NULLIF(NULLIF(wpgt, 'nan'), 'None')::DECIMAL(18, 3) AS wpgt,
    NULLIF(NULLIF(pres, 'nan'), 'None')::DECIMAL(18, 3) AS pres,
    NULLIF(NULLIF(tsun, 'nan'), 'None')::DECIMAL(18, 3) AS tsun,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'meteostat' AS source_system,
    'point__daily' AS source_table,
    CONCAT(latitude, '|', longitude) AS coords_bk,
    CONCAT(source_system, '|', latitude, '|', longitude, '|', date) AS weather_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(coords_bk)::BLOB AS coords_hk,
    @generate_surrogate_key__sha_256(weather_bk)::BLOB AS weather_hk,
    @generate_surrogate_key__sha_256(weather_bk, valid_from)::BLOB AS weather_pit_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data