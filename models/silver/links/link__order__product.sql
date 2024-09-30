MODEL (
  name silver.link__order__product,
  cron '@hourly',
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := order_hk__product_hk),
    NOT_NULL(columns := (order_hk__product_hk, order_hk, product_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__items,
  link_key := order_hk__product_hk,
  hash_keys := (order_hk, product_hk),
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from,
  load_end_date := valid_to
)