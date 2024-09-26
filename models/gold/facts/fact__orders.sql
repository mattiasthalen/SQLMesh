/* Type 2 slowly changing fact table for order lines */
MODEL (
  name gold.fact__orders,
  cron '@hourly',
  kind FULL,
  grain item_pit_hk,
  references (order_pit_hk, customer_pit_hk, product_pit_hk, store_pit_hk),
  audits (UNIQUE_VALUES(columns := item_pit_hk), NOT_NULL(columns := item_pit_hk))
);

SELECT
  sat__item.item_pit_hk, /* Primary point in time hash key to the order line */
  sat__order.order_pit_hk, /* Foreign point in time hash key to the order */
  sat__customer.customer_pit_hk, /* Foreign point in time hash key to the customer */
  sat__product.product_pit_hk, /* Foreign point in time hash key to the product */
  sat__store.store_pit_hk, /* Foreign point in time hash key to the store */
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
FROM silver.hub__order
INNER JOIN silver.sat__order
  ON hub__order.order_hk = sat__order.order_hk
INNER JOIN silver.link__customer__order
  ON hub__order.order_hk = link__customer__order.order_hk
  AND sat__order.valid_from BETWEEN link__customer__order.valid_from AND link__customer__order.valid_to
INNER JOIN silver.hub__customer
  ON link__customer__order.customer_hk = hub__customer.customer_hk
INNER JOIN silver.sat__customer
  ON hub__customer.customer_hk = sat__customer.customer_hk
  AND sat__order.valid_from BETWEEN sat__customer.valid_from AND sat__customer.valid_to
INNER JOIN silver.link__order__product
  ON hub__order.order_hk = link__order__product.order_hk
  AND sat__order.valid_from BETWEEN link__order__product.valid_from AND link__order__product.valid_to
INNER JOIN silver.sat__item
  ON link__order__product.order_hk__product_hk = sat__item.order_hk__product_hk
  AND sat__order.valid_from BETWEEN sat__item.valid_from AND sat__item.valid_to
INNER JOIN silver.hub__product
  ON link__order__product.product_hk = hub__product.product_hk
INNER JOIN silver.sat__product
  ON hub__product.product_hk = sat__product.product_hk
  AND sat__order.valid_from BETWEEN sat__product.valid_from AND sat__product.valid_to
INNER JOIN silver.link__order__store
  ON hub__order.order_hk = link__order__store.order_hk
  AND sat__order.valid_from BETWEEN link__order__store.valid_from AND link__order__store.valid_to
INNER JOIN silver.hub__store
  ON link__order__store.store_hk = hub__store.store_hk
INNER JOIN silver.sat__store
  ON hub__store.store_hk = sat__store.store_hk
  AND sat__order.valid_from BETWEEN sat__store.valid_from AND sat__store.valid_to;

@export_to_parquet('gold.fact__orders', 'exports')