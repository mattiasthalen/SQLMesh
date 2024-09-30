/* Type 2 slowly changing fact table for order lines */
MODEL (
  name gold.fact__orders,
  cron '@hourly',
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
  sat__item.source_system, /* Source system of the fact record */
  sat__item.source_table, /* Source table of the fact record */
  sat__item.valid_from, /* Timestamp when the order line record became valid (inclusive) */
  sat__item.valid_to /* Timestamp of when the order line record expired (exclusive) */
FROM silver /* Links */.link__customer__order
INNER JOIN silver.link__order__product
  ON link__customer__order.order_hk = link__order__product.order_hk
INNER JOIN silver.link__order__store
  ON link__customer__order.order_hk = link__order__store.order_hk
INNER JOIN silver.link__store__city
  ON link__order__store.store_hk = link__store__city.store_hk
INNER JOIN silver.link__city__coords
  ON link__store__city.city_hk = link__city__coords.city_hk
/* Hubs */
INNER JOIN silver.hub__customer
  ON link__customer__order.customer_hk = hub__customer.customer_hk
INNER JOIN silver.hub__order
  ON link__customer__order.order_hk = hub__order.order_hk
INNER JOIN silver.hub__store
  ON link__order__store.store_hk = hub__store.store_hk
INNER JOIN silver.hub__city
  ON link__store__city.city_hk = hub__city.city_hk
INNER JOIN silver.hub__coords
  ON link__city__coords.coords_hk = hub__coords.coords_hk
INNER JOIN silver.hub__product
  ON link__order__product.product_hk = hub__product.product_hk
/* Satellites */
LEFT JOIN silver.sat__order
  ON hub__order.order_hk = sat__order.order_hk
LEFT JOIN silver.sat__item
  ON link__order__product.order_hk__product_hk = sat__item.order_hk__product_hk
  AND sat__order.ordered_at BETWEEN sat__item.valid_from AND sat__item.valid_to
LEFT JOIN silver.sat__product
  ON hub__product.product_hk = sat__product.product_hk
  AND sat__order.ordered_at BETWEEN sat__product.valid_from AND sat__product.valid_to
LEFT JOIN silver.sat__customer
  ON hub__customer.customer_hk = sat__customer.customer_hk
  AND sat__order.ordered_at BETWEEN sat__customer.valid_from AND sat__customer.valid_to
LEFT JOIN silver.sat__store
  ON hub__store.store_hk = sat__store.store_hk
  AND sat__order.ordered_at BETWEEN sat__store.valid_from AND sat__store.valid_to
LEFT JOIN silver.sat__city
  ON hub__city.city_hk = sat__city.city_hk
  AND sat__order.ordered_at BETWEEN sat__city.valid_from AND sat__city.valid_to
LEFT JOIN silver.sat__weather
  ON hub__coords.coords_hk = sat__weather.coords_hk
  AND CAST(sat__order.ordered_at AS DATE) = sat__weather.date
  AND sat__order.ordered_at BETWEEN sat__weather.valid_from AND sat__weather.valid_to;

@export_to_parquet('gold.fact__orders', 'exports')