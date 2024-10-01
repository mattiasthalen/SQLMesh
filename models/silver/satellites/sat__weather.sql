MODEL (
  name silver.sat__weather,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := weather_pit_hk), NOT_NULL(columns := weather_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__meteostat__point__daily,
  hash_key := weather_hk,
  pit_key := weather_pit_hk,
  payload := (
    coords_hk,
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
    tsun
  ),
  source_system := source_system,
  source_table := source_table,
  load_date := snapshot_valid_from,
  load_end_date := snapshot_valid_to
)