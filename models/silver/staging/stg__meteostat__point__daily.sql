MODEL (
  name silver.stg__meteostat__point__daily,
  kind VIEW,
  grain city_hk,
  references (
    coords_hk
  ),
  audits (UNIQUE_VALUES(columns := coords_hk), NOT_NULL(columns := coords_hk))
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
), final_data AS (
  SELECT
    'meteostat' AS source_system,
    'point__daily' AS source_table,
    @generate_surrogate_key__sha_256(latitude, longitude)::BLOB AS coords_hk,
    @generate_surrogate_key__sha_256(latitude, longitude, valid_from)::BLOB AS coords_pit_hk,
    CONCAT(latitude, '|', longitude) AS coords_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data