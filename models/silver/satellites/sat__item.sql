MODEL (
  name silver.sat__item,
  kind FULL,
  audits (UNIQUE_VALUES(columns := item_pit_hk), NOT_NULL(columns := item_pit_hk))
);

SELECT
  order_hk__product_hk,
  item_hk,
  item_pit_hk,
  quantity,
  source_system,
  source_table,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__items