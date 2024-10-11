/* Type 2 slowly changing dimension table for customers */
MODEL (
  kind FULL,
  grain weather_pit_hk,
  audits (UNIQUE_VALUES(columns := weather_pit_hk), NOT_NULL(columns := weather_pit_hk))
);

SELECT
  ROW_NUMBER() OVER () AS weather_pit_id, /* Auto numbered version of the point in time hash key */
  weather_hk, /* Surrogate hash key of the weather stats */
  weather_pit_hk, /* Point in time hash key of the weather stats */
  latitude AS weather__latitude, /* Latitude of the weather stats */
  longitude AS weather__longitude, /* Longitude of the weather stats */
  date AS weather__date, /* The date of the weather stats */
  tavg AS weather__temperature__avg, /* The average air temperature in °C */
  tmin AS weather__temperature__min, /* The minimum air temperature in °C */
  tmax AS weather__temperature__max, /* The maximum air temperature in °C */
  prcp AS weather__precipitation, /* The daily precipitation total in mm	 */
  snow AS weather__snow_depth, /* The maximum snow depth in mm */
  wdir AS weather__wind__direction, /* The average wind direction in degrees (°) */
  wspd AS weather__wind__speed, /* The average wind speed in km/h */
  wpgt AS weather__wind__peak_gust, /* The peak wind gust in km/h */
  pres AS weather__pressure, /* The average sea-level air pressure in hPa */
  tsun AS weather__daily_sunshine, /* The daily sunshine total in minutes (m) */
  source_system AS weather__source_system, /* Source system of the weather record */
  source_table AS weather__source_table, /* Source table of the weather record */
  cdc_updated_at AS weather__record_updated_at, /* Timestamp when the weather record was updated */
  cdc_valid_from AS weather__record_valid_from, /* Timestamp when the weather record became valid (inclusive) */
  cdc_valid_to AS weather__record_valid_to /* Timestamp of when the weather record expired (exclusive) */
FROM silver.stg__meteostat__point__daily;

@export_to_parquet('gold.dim__weather', 'exports')