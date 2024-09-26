MODEL (
  name silver.hub__supply,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := supply_hk), NOT_NULL(columns := supply_hk))
);

SELECT
  supply_hk,
  supply_bk,
  source,
  MIN(valid_from) AS valid_from
FROM silver.stg__jaffle_shop__supplies
GROUP BY
  supply_hk,
  supply_bk,
  source