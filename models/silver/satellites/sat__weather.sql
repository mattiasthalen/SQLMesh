MODEL (
  name silver.sat__weather,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := coords_pit_hk), NOT_NULL(columns := coords_pit_hk))
);

SELECT
  coords_hk,
  coords_pit_hk,
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