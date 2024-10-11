MODEL (
  kind FULL,
  grain weather_pit_hk,
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
    NULLIF(NULLIF(snow, 'nan'), 'None')::INT AS snow,
    NULLIF(NULLIF(wdir, 'nan'), 'None')::INT AS wdir,
    NULLIF(NULLIF(wspd, 'nan'), 'None')::DECIMAL(18, 3) AS wspd,
    NULLIF(NULLIF(wpgt, 'nan'), 'None')::DECIMAL(18, 3) AS wpgt,
    NULLIF(NULLIF(pres, 'nan'), 'None')::DECIMAL(18, 3) AS pres,
    NULLIF(NULLIF(tsun, 'nan'), 'None')::INT AS tsun,
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
), ghost_record AS (
  SELECT
    NULL AS latitude,
    NULL AS longitude,
    NULL AS date,
    NULL AS tavg,
    NULL AS tmin,
    NULL AS tmax,
    NULL AS prcp,
    NULL AS snow,
    NULL AS wdir,
    NULL AS wspd,
    NULL AS wpgt,
    NULL AS pres,
    NULL AS tsun,
    @execution_ts AS cdc_updated_at,
    '1970-01-01 00:00:00'::TIMESTAMP AS cdc_valid_from,
    '9999-12-31 23:59:59'::TIMESTAMP AS cdc_valid_to
), union_data AS (
  SELECT
    *
  FROM casted_data
  UNION ALL
  SELECT
    *
  FROM ghost_record
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(latitude, longitude) AS coords_hk,
    @generate_surrogate_key__sha_256(latitude, longitude, date) AS weather_hk,
    @generate_surrogate_key__sha_256(latitude, longitude, date, cdc_valid_from) AS weather_pit_hk,
    *
  FROM union_data
)
SELECT
  *
FROM final_data