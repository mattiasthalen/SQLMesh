MODEL (
  name silver.sat__city,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := city_pit_hk), NOT_NULL(columns := city_pit_hk))
);

@data_vault__load_satellite(
  source := silver.stg__seed__cities,
  hash_key := city_hk,
  pit_key := city_pit_hk,
  payload := (city, latitude, longitude),
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from,
  load_end_date := valid_to
)