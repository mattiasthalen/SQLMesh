MODEL (
  name silver.stg__jaffle_shop__supplies,
  kind VIEW,
  grain supply_pit_hk,
  references (supply_hk, product_hk, supply_hk__product_hk)
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__supplies
), casted_data AS (
  SELECT
    id::BLOB AS id,
    name::TEXT AS name,
    cost::DECIMAL(18, 3) AS cost,
    perishable::BOOLEAN AS perishable,
    sku::TEXT AS sku,
    filename::TEXT AS filename,
    cdc_updated_at::TIMESTAMP AS cdc_updated_at,
    cdc_valid_from::TIMESTAMP AS cdc_valid_from,
    COALESCE(cdc_valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS cdc_valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_supplies' AS source_table,
    CONCAT(source_system, '|', id) AS supply_bk,
    CONCAT(source_system, '|', sku) AS product_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(supply_bk) AS supply_hk,
    @generate_surrogate_key__sha_256(supply_bk, cdc_valid_from) AS supply_pit_hk,
    @generate_surrogate_key__sha_256(product_bk) AS product_hk,
    @generate_surrogate_key__sha_256(supply_bk, product_bk) AS supply_hk__product_hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data