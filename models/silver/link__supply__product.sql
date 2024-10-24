MODEL (
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := supply_hk__product_hk),
    NOT_NULL(columns := (supply_hk__product_hk, supply_hk, product_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__supplies,
  link_key := supply_hk__product_hk,
  hash_keys := (supply_hk, product_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)