MODEL (
  name silver.link__store__city,
  cron '@hourly',
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := store_hk__city__hk),
    NOT_NULL(columns := (store_hk__city__hk, store_hk, city_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__stores,
  link_key := store_hk__city__hk,
  hash_keys := (store_hk, city_hk),
  source_system := source_system,
  source_table := source_table,
  load_date := cdc_valid_from,
  load_end_date := cdc_valid_to
)