MODEL (
  name silver.link__supply__product,
  cron '@hourly',
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
  load_date := cdc_valid_from,
  load_end_date := cdc_valid_to
)