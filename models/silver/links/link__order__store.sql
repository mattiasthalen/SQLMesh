MODEL (
  name silver.link__order__store,
  kind VIEW,
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
  load_date := valid_from,
  load_end_date := valid_to
)