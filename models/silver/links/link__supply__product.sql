MODEL (
  name silver.link__supply__product,
  kind VIEW,
  audits (
    UNIQUE_VALUES(columns := supply_hk__product_hk),
    NOT_NULL(columns := (supply_hk__product_hk, supply_hk, product_hk))
  )
);

SELECT
  supply_hk__product_hk,
  supply_hk,
  product_hk,
  source_system,
  source_table,
  MIN(valid_from) AS valid_from,
  MAX(valid_to) AS valid_to
FROM silver.stg__jaffle_shop__supplies
GROUP BY
  supply_hk__product_hk,
  supply_hk,
  product_hk,
  source_system,
  source_table