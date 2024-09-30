MODEL (
  name silver.hub__customer,
  cron '@hourly',
  kind FULL,
  audits (UNIQUE_VALUES(columns := customer_hk), NOT_NULL(columns := customer_hk))
);

@data_vault__load_hub(
  sources := (silver.stg__jaffle_shop__customers, silver.stg__jaffle_shop__orders),
  business_key := customer_bk,
  hash_key := customer_hk,
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from
)