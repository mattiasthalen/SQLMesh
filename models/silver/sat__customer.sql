MODEL (
  cron '@hourly',
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (cdc_updated_at, '%Y-%m-%d %H:%M:%S')
  ),
  audits (
    UNIQUE_VALUES(columns := customer_pit_hk),
    NOT_NULL(columns := customer_pit_hk),
    ASSERT_FK_PK_INTEGRITY(
      target_table := silver.hub__country,
      fk_column := country_hk,
      pk_column := country_hk
    )
  ),
  depends_on [silver.hub__country]
);

@data_vault__load_satellite(
  source := silver.stg__jaffle_shop__customers,
  hash_key := customer_hk,
  pit_key := customer_pit_hk,
  payload := (id, name, filename),
  source_system := source_system,
  source_table := source_table,
  updated_at := cdc_updated_at,
  valid_from := cdc_valid_from,
  valid_to := cdc_valid_to
)