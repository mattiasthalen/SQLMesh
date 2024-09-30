/* Type 2 slowly changing dimension table for customers */
MODEL (
  name platinum.dim__weather__ux,
  kind VIEW,
  grain weather_pit_hk,
  audits (UNIQUE_VALUES(columns := weather_pit_hk), NOT_NULL(columns := weather_pit_hk))
);

SELECT
  weather_hk, /* Surrogate hash key of the weather stats */
  weather_pit_hk, /* Point in time hash key of the weather stats */
  weather__latitude AS "Weather - Latitude", /* Latitude of the weather stats */
  weather__longitude AS "Weather - Longitude", /* Longitude of the weather stats */
  weather__date AS "Weather - Date", /* The date of the weather stats */
  weather__temperature__avg AS "Weather - Temperature - Average", /* The average air temperature in °C */
  weather__temperature__min AS "Weather - Temperature - Min", /* The minimum air temperature in °C */
  weather__temperature__max AS "Weather - Temperature - Max", /* The maximum air temperature in °C */
  weather__precipitation AS "Weather - Precipitation", /* The daily precipitation total in mm	 */
  weather__snow_depth AS "Weather - Snow Depth", /* The maximum snow depth in mm */
  weather__wind__direction AS "Weather - Wind - Direction", /* The average wind direction in degrees (°) */
  weather__wind__speed AS "Weather - Wind - Speed", /* The average wind speed in km/h */
  weather__wind__peak_gust AS "Weather - Wind - Peak Gust", /* The peak wind gust in km/h */
  weather__pressure AS "Weather - Pressure", /* The average sea-level air pressure in hPa */
  weather__daily_sunshine AS "Weather - Daily Sunshine", /* The daily sunshine total in minutes (m) */
  weather__source_system AS "Weather - Source System", /* Source system of the customer record */
  weather__source_table AS "Weather - Source Table", /* Source table of the customer record */
  weather__record_valid_from AS "Weather - Record Valid From", /* Timestamp when the customer record became valid (inclusive) */
  weather__record_valid_to AS "Weather - Record Valid To" /* Timestamp of when the customer record expired (exclusive) */
FROM gold.dim__weather;

@export_to_parquet('platinum.dim__weather__ux', 'exports')