MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
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
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)