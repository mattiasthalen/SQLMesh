MODEL (
  name silver.sat__weather,
  kind FULL,
  audits (UNIQUE_VALUES(columns := weather_pit_hk), NOT_NULL(columns := weather_pit_hk))
);

SELECT
  coords_hk,
  weather_hk,
  weather_pit_hk,
  latitude,
  longitude,
  date,
  tavg,
  tmin,
  tmax,
  prcp,
  snow,
  wdir,
  wspd,
  wpgt,
  pres,
  tsun,
  source_system,
  source_table,
  valid_from,
  valid_to
FROM silver.stg__meteostat__point__daily