MODEL (
  kind FULL,
  audits (UNIQUE_VALUES(columns := tweeter_bk), NOT_NULL(columns := tweeter_bk))
);

@data_vault__load_hub(
  sources := silver.stg__jaffle_shop__tweets,
  business_key := tweeter_bk,
  hash_key := tweeter_hk,
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)