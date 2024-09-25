MODEL (
  name silver.sat__item,
  kind VIEW
);

SELECT
  order_hk__product_hk,
  item_hk,
  item_pit_hk,
  quantity,
  source,
  valid_from,
  valid_to
FROM silver.stg__jaffle_shop__items