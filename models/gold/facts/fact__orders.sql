/* Type 2 slowly changing fact table for order lines */
MODEL (
  name gold.fact__orders,
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
  @generate_surrogate_key__sha_256(
    sat__item.item_pit_hk,
    sat__order.order_pit_hk,
    sat__customer.customer_pit_hk,
    sat__product.product_pit_hk,
    sat__store.store_pit_hk,
    sat__city.city_pit_hk,
    sat__weather.weather_pit_hk
  ) AS fact_record_hk, /* Primary hash key for the fact record */
  sat__item.item_pit_hk, /* Foreign point in time hash key to the order line */
  sat__order.order_pit_hk, /* Foreign point in time hash key to the order */
  sat__customer.customer_pit_hk, /* Foreign point in time hash key to the customer */
  sat__product.product_pit_hk, /* Foreign point in time hash key to the product */
  sat__store.store_pit_hk, /* Foreign point in time hash key to the store */
  sat__city.city_pit_hk, /* Foreign point in time hash key to the city */
  sat__weather.weather_pit_hk, /* Foreign point in time hash key to the weather stats */
  sat__order.ordered_at, /* Timestamp of when the order was placed */
  sat__item.quantity, /* Ordered quantity */
  sat__product.price, /* Unit price */
  sat__store.tax_rate, /* Tax rate for the order */
  sat__product.price * sat__item.quantity AS subtotal_price, /* Subtotal for the order line */
  subtotal_price * sat__store.tax_rate AS tax, /* Tax paid for the order line */
  subtotal_price + tax AS price_with_tax, /* Price, including tax, for the order line */
  GREATEST(
    sat__order.cdc_updated_at,
    sat__item.cdc_updated_at,
    sat__product.cdc_updated_at,
    sat__customer.cdc_updated_at,
    sat__store.cdc_updated_at,
    sat__city.cdc_updated_at,
    sat__weather.cdc_updated_at
  ) AS fact_record__updated_at, /* Timestamp when the fact record was updated */
  GREATEST(
    sat__order.cdc_valid_from,
    sat__item.cdc_valid_from,
    sat__product.cdc_valid_from,
    sat__customer.cdc_valid_from,
    sat__store.cdc_valid_from,
    sat__city.cdc_valid_from,
    sat__weather.cdc_valid_from
  ) AS fact_record__valid_from, /* Timestamp when the fact record became valid (inclusive) */
  LEAST(
    sat__order.cdc_valid_from,
    sat__item.cdc_valid_from,
    sat__product.cdc_valid_from,
    sat__customer.cdc_valid_from,
    sat__store.cdc_valid_from,
    sat__city.cdc_valid_from,
    sat__weather.cdc_valid_from
  ) AS fact_record__valid_to /* Timestamp of when the fact record expired (exclusive) */
/* Links */
FROM silver.bridge__customer__order__store__city__coords
INNER JOIN silver.bridge__customer__order__product
  ON bridge__customer__order__store__city__coords.customer_hk = bridge__customer__order__product.customer_hk
  AND bridge__customer__order__store__city__coords.order_hk = bridge__customer__order__product.order_hk
/* Satellites */
LEFT JOIN silver.sat__order
  ON bridge__customer__order__store__city__coords.order_hk = sat__order.order_hk
LEFT JOIN silver.sat__item
  ON bridge__customer__order__product.order_hk__product_hk = sat__item.order_hk__product_hk
  AND sat__order.ordered_at BETWEEN sat__item.cdc_valid_from AND sat__item.cdc_valid_to
LEFT JOIN silver.sat__product
  ON bridge__customer__order__product.product_hk = sat__product.product_hk
  AND sat__order.ordered_at BETWEEN sat__product.cdc_valid_from AND sat__product.cdc_valid_to
LEFT JOIN silver.sat__customer
  ON bridge__customer__order__store__city__coords.customer_hk = sat__customer.customer_hk
  AND sat__order.ordered_at BETWEEN sat__customer.cdc_valid_from AND sat__customer.cdc_valid_to
LEFT JOIN silver.sat__store
  ON bridge__customer__order__store__city__coords.store_hk = sat__store.store_hk
  AND sat__order.ordered_at BETWEEN sat__store.cdc_valid_from AND sat__store.cdc_valid_to
LEFT JOIN silver.sat__city
  ON bridge__customer__order__store__city__coords.city_hk = sat__city.city_hk
  AND sat__order.ordered_at BETWEEN sat__city.cdc_valid_from AND sat__city.cdc_valid_to
LEFT JOIN silver.sat__weather
  ON bridge__customer__order__store__city__coords.coords_hk = sat__weather.coords_hk
  AND CAST(sat__order.ordered_at AS DATE) = sat__weather.date
  AND sat__order.ordered_at BETWEEN sat__weather.cdc_valid_from AND sat__weather.cdc_valid_to;

@export_to_parquet('gold.fact__orders', 'exports')