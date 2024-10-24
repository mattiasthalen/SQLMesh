MODEL (
  kind FULL,
  audits (UNIQUE_VALUES(columns := order_bk), NOT_NULL(columns := order_bk))
);

@data_vault__load_hub(
  sources := (silver.stg__jaffle_shop__orders, silver.stg__jaffle_shop__items),
  business_key := order_bk,
  hash_key := order_hk,
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)