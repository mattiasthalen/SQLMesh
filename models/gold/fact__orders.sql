/* Type 2 slowly changing fact table for order lines */
MODEL (
enabled false,
  kind FULL,
  grain fact_record_hk,
  references (
    item_pit_hk,
    order_pit_hk,
    customer_pit_hk,
    product_pit_hk,
    store_pit_hk,
    city_pit_hk,
    weather_pit_hk
  ),
  audits (UNIQUE_VALUES(columns := fact_record_hk), NOT_NULL(columns := fact_record_hk))
);

SELECT
    bridge_record_hk AS fact_record_hk /* Primary hash key for the fact record */
--  ROW_NUMBER() OVER () AS fact_record_id, /* Auto numbered version of the fact record hash key */
--  stg__jaffle_shop__items.item_pit_hk, /* Foreign point in time hash key to the order line */
--  stg__jaffle_shop__orders.order_pit_hk, /* Foreign point in time hash key to the order */
--  stg__jaffle_shop__customers.customer_pit_hk, /* Foreign point in time hash key to the customer */
--  stg__jaffle_shop__products.product_pit_hk, /* Foreign point in time hash key to the product */
--  stg__jaffle_shop__stores.store_pit_hk, /* Foreign point in time hash key to the store */
--  stg__seed__cities.city_pit_hk, /* Foreign point in time hash key to the city */
--  stg__meteostat__point__daily.weather_pit_hk, /* Foreign point in time hash key to the weather stats */
--  --dim__customers.customer_pit_id, /* Auto numbered key for the customer */
--  --dim__products.product_pit_id, /* Auto numbered key for the product */
--  --dim__stores.store_pit_id, /* Auto numbered key for the store */
--  --dim__cities.city_pit_id, /* Auto numbered key for the city */
--  --dim__weather.weather_pit_id, /* Auto numbered key for the weather stats */
--  stg__jaffle_shop__orders.ordered_at, /* Timestamp of when the order was placed */
--  stg__jaffle_shop__items.quantity, /* Ordered quantity */
--  stg__jaffle_shop__products.price, /* Unit price */
--  stg__jaffle_shop__stores.tax_rate, /* Tax rate for the order */
--  price * quantity AS subtotal_price, /* Subtotal for the order line */
--  subtotal_price * tax_rate AS tax, /* Tax paid for the order line */
--  subtotal_price + tax AS price_with_tax, /* Price, including tax, for the order line */
--  GREATEST(
--    stg__jaffle_shop__items.cdc_updated_at,
--    stg__jaffle_shop__orders.cdc_updated_at,
--    stg__jaffle_shop__customers.cdc_updated_at,
--    stg__jaffle_shop__products.cdc_updated_at,
--    stg__jaffle_shop__stores.cdc_updated_at,
--    stg__seed__cities.cdc_updated_at,
--    stg__meteostat__point__daily.cdc_updated_at
--  ) AS fact_record__updated_at, /* Timestamp when the fact record was updated */
--  GREATEST(
--    stg__jaffle_shop__items.cdc_valid_from,
--    stg__jaffle_shop__orders.cdc_valid_from,
--    stg__jaffle_shop__customers.cdc_valid_from,
--    stg__jaffle_shop__products.cdc_valid_from,
--    stg__jaffle_shop__stores.cdc_valid_from,
--    stg__seed__cities.cdc_valid_from,
--    stg__meteostat__point__daily.cdc_valid_from
--  ) AS fact_record__valid_from, /* Timestamp when the fact record became valid (inclusive) */
--  LEAST(
--    stg__jaffle_shop__items.cdc_valid_to,
--    stg__jaffle_shop__orders.cdc_valid_to,
--    stg__jaffle_shop__customers.cdc_valid_to,
--    stg__jaffle_shop__products.cdc_valid_to,
--    stg__jaffle_shop__stores.cdc_valid_to,
--    stg__seed__cities.cdc_valid_to,
--    stg__meteostat__point__daily.cdc_valid_to
--  ) AS fact_record__valid_to /* Timestamp of when the fact record expired (exclusive) */
FROM silver.stg__jaffle_shop__orders
INNER JOIN silver.stg__jaffle_shop__items
  ON stg__jaffle_shop__orders.order_hk = stg__jaffle_shop__items.order_hk
  AND stg__jaffle_shop__orders.ordered_at BETWEEN stg__jaffle_shop__items.cdc_valid_from AND stg__jaffle_shop__items.cdc_valid_to
INNER JOIN silver.stg__jaffle_shop__customers
  ON stg__jaffle_shop__orders.customer_hk = stg__jaffle_shop__customers.customer_hk
  AND stg__jaffle_shop__orders.ordered_at BETWEEN stg__jaffle_shop__customers.cdc_valid_from AND stg__jaffle_shop__customers.cdc_valid_to
INNER JOIN silver.stg__jaffle_shop__products
  ON stg__jaffle_shop__items.product_hk = stg__jaffle_shop__products.product_hk
  AND stg__jaffle_shop__orders.ordered_at BETWEEN stg__jaffle_shop__products.cdc_valid_from AND stg__jaffle_shop__products.cdc_valid_to
INNER JOIN silver.stg__jaffle_shop__stores
  ON stg__jaffle_shop__orders.store_hk = stg__jaffle_shop__stores.store_hk
  AND stg__jaffle_shop__orders.ordered_at BETWEEN stg__jaffle_shop__stores.cdc_valid_from AND stg__jaffle_shop__stores.cdc_valid_to
INNER JOIN silver.stg__seed__cities
  ON stg__jaffle_shop__stores.city_hk = stg__seed__cities.city_hk
  AND stg__jaffle_shop__orders.ordered_at BETWEEN stg__seed__cities.cdc_valid_from AND stg__seed__cities.cdc_valid_to
INNER JOIN silver.stg__meteostat__point__daily
  ON stg__seed__cities.coords_hk = stg__meteostat__point__daily.coords_hk
  AND stg__jaffle_shop__orders.ordered_at BETWEEN stg__meteostat__point__daily.cdc_valid_from AND stg__meteostat__point__daily.cdc_valid_to
/* Dimensions */
INNER JOIN gold.dim__cities
    ON bridge__orders_by_ordered_at.city_pit_hk = dim__cities.city_pit_hk
INNER JOIN gold.dim__products
    ON bridge__orders_by_ordered_at.product_pit_hk = dim__products.product_pit_hk
INNER JOIN gold.dim__stores
    ON bridge__orders_by_ordered_at.store_pit_hk = dim__stores.store_pit_hk
INNER JOIN gold.dim__customers
    ON bridge__orders_by_ordered_at.customer_pit_hk = dim__customers.customer_pit_hk
INNER JOIN gold.dim__weather
    ON bridge__orders_by_ordered_at.weather_pit_hk = dim__weather.weather_pit_hk
;
@export_to_parquet('gold.fact__orders', 'exports')