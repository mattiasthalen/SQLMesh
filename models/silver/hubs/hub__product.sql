MODEL (
  name silver.hub__product,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := product_bk), NOT_NULL(columns := product_bk))
);

@data_vault__load_hub(
  sources := (
    silver.stg__jaffle_shop__products,
    silver.stg__jaffle_shop__items,
    silver.stg__jaffle_shop__supplies
  ),
  business_key := product_bk,
  hash_key := product_hk,
  source_system := source_system,
  source_table := source_table,
  load_date := valid_from
)