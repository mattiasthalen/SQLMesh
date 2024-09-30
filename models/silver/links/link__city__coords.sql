MODEL (
  name silver.link__city__coords,
  cron '@hourly',
  kind FULL,
  audits (
    UNIQUE_VALUES(columns := city_hk__coords_hk),
    NOT_NULL(columns := (city_hk__coords_hk, city_hk, coords_hk))
  )
);

@data_vault__load_link(
  sources := silver.stg__seed__cities,
  link_key := city_hk__coords_hk,
  hash_keys := (city_hk, coords_hk),
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from,
  load_end_date := valid_to
)