MODEL (
  name silver.sat__city,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := city_pit_hk), NOT_NULL(columns := city_pit_hk))
);

SELECT
  city_hk,
  city_pit_hk,
  city,
  latitude,
  longitude,
  source_system,
  source_table,
  valid_from,
  valid_to
FROM silver.stg__seed__cities