/* Type 2 slowly changing fact table for order lines, UX formatted */
MODEL (
  kind VIEW,
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
  fact_record_id, /* Auto numbered version of the fact record hash key */
  fact_record_hk AS "fact_record_hk", /* Primary hash key for the fact record */
  item_pit_hk AS "item_pit_hk", /* Primary point in time hash key to the order line */
  order_pit_hk AS "order_pit_hk", /* Foreign point in time hash key to the order */
  customer_pit_hk AS "customer_pit_hk", /* Foreign point in time hash key to the customer */
  product_pit_hk AS "product_pit_hk", /* Foreign point in time hash key to the product */
  store_pit_hk AS "store_pit_hk", /* Foreign point in time hash key to the store */
  city_pit_hk AS "city_pit_hk", /* Foreign point in time hash key to the city */
  weather_pit_hk AS "weather_pit_hk", /* Foreign point in time hash key to the weather stats */
  customer_pit_id, /* Auto numbered key for the customer */
  product_pit_id, /* Auto numbered key for the product */
  store_pit_id, /* Auto numbered key for the store */
  city_pit_id, /* Auto numbered key for the city */
  weather_pit_id, /* Auto numbered key for the weather stats */
  ordered_at AS "Ordered At", /* Timestamp of when the order was placed */
  quantity AS "Quantity", /* Ordered quantity */
  price AS "Unit Price", /* Unit price */
  tax_rate AS "Tax Rate", /* Tax rate for the order */
  subtotal_price AS "Subtotal", /* Subtotal for the order line */
  tax AS "Tax Paid", /* Tax paid for the order line */
  price_with_tax AS "Price With Tax", /* Price, including tax, for the order line */
  fact_record__updated_at AS "Fact Record - Updated At", /* Timestamp when the fact record was updated */
  fact_record__valid_from AS "Fact Record - Valid From", /* Timestamp when the fact record record became valid (inclusive) */
  fact_record__valid_to AS "Fact Record - Valid To" /* Timestamp of when the fact record record expired (exclusive) */
FROM gold.fact__orders;