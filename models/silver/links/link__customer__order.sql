MODEL (
  name silver.link__customer__order,
  cron '@hourly',
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := customer_hk__order_hk),
    NOT_NULL(columns := (customer_hk__order_hk, customer_hk, order_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__orders,
  link_key := customer_hk__order_hk,
  hash_keys := (customer_hk, order_hk),
  source_system := source_system,
  source_table := source_table,
  load_date := snapshot_valid_from,
  load_end_date := snapshot_valid_to
)