MODEL (
  name silver.link__city__coords,
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := city_hk__coords_hk),
    NOT_NULL(columns := (city_hk__coords_hk, city_hk, coords_hk))
  )
);

SELECT
  city_hk__coords_hk,
  city_hk,
  coords_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__seed__cities
GROUP BY
  city_hk__coords_hk,
  city_hk,
  coords_hk,
  source_system,
  source_table