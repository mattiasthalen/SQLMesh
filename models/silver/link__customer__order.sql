MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := customer_hk__order_hk),
    NOT_NULL(columns := (customer_hk__order_hk, customer_hk, order_hk)),
    ASSERT_FK_PK_INTEGRITY(
      target_table := silver.hub__customer,
      fk_column := customer_hk,
      pk_column := customer_hk
    ),
    ASSERT_FK_PK_INTEGRITY(target_table := silver.hub__order, fk_column := order_hk, pk_column := order_hk)
  ),
  depends_on [silver.hub__customer, silver.hub__order]
);

@data_vault__load_link(
  sources := silver.stg__jaffle_shop__orders,
  link_key := customer_hk__order_hk,
  hash_keys := (customer_hk, order_hk),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at
)