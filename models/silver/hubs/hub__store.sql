MODEL (
  name silver.hub__store,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := store_hk), NOT_NULL(columns := store_hk))
);

SELECT
  store_hk,
  store_bk,
  source,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__stores
GROUP BY
  store_hk,
  store_bk,
  source