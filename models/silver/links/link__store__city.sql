MODEL (
  name silver.link__store__city,
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := store_hk__city__hk),
    NOT_NULL(columns := (store_hk__city__hk, store_hk, city_hk))
  )
);

SELECT
  store_hk__city__hk,
  store_hk,
  city_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__stores
GROUP BY
  store_hk__city__hk,
  store_hk,
  city_hk,
  source_system,
  source_table