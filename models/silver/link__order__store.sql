MODEL (
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := order_hk__store_hk),
    NOT_NULL(columns := (order_hk__store_hk, order_hk, store_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__orders,
  link_key := order_hk__store_hk,
  hash_keys := (order_hk, store_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)