/* Type 2 slowly changing fact table for order lines, UX formatted */
MODEL (
  name platinum.fact__orders__ux,
  kind VIEW,
  grain item_pit_hk,
  references ("order_pit_hk", "customer_pit_hk", "product_pit_hk", "store_pit_hk"),
  audits (UNIQUE_VALUES(columns := item_pit_hk), NOT_NULL(columns := item_pit_hk))
);

SELECT
  item_pit_hk AS "item_pit_hk", /* Primary point in time hash key to the order line */
  order_pit_hk AS "order_pit_hk", /* Foreign point in time hash key to the order */
  customer_pit_hk AS "customer_pit_hk", /* Foreign point in time hash key to the customer */
  product_pit_hk AS "product_pit_hk", /* Foreign point in time hash key to the product */
  store_pit_hk AS "store_pit_hk", /* Foreign point in time hash key to the store */
  ordered_at AS "Ordered At", /* Timestamp of when the order was placed */
  quantity AS "Quantity", /* Ordered quantity */
  price AS "Unit Price", /* Unit price */
  tax_rate AS "Tax Rate", /* Tax rate for the order */
  subtotal_price AS "Subtotal", /* Subtotal for the order line */
  tax AS "Tax Paid", /* Tax paid for the order line */
  price_with_tax AS "Price With Tax", /* Price, including tax, for the order line */
  valid_from AS "Valid From", /* Timestamp when the order line record became valid (inclusive) */
  valid_to AS "Valid To" /* Timestamp of when the order line record expired (exclusive) */
FROM gold.fact__orders;

@export_to_parquet('platinum.fact__orders__ux', 'exports')