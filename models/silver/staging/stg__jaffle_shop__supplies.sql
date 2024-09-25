MODEL (
  name silver.stg__jaffle_shop__supplies,
  kind VIEW
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__supplies
), casted_data AS (
  SELECT
    id::UUID AS id,
    name::TEXT AS name,
    cost::DECIMAL(18, 3) AS cost,
    perishable::BOOLEAN AS perishable,
    sku::TEXT AS sku,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(id)::BLOB AS supply_hk,
    @generate_surrogate_key__sha_256(id, valid_from)::BLOB AS supply_pit_hk,
    @generate_surrogate_key__sha_256(sku)::BLOB AS product_hk,
    @generate_surrogate_key__sha_256(id, sku)::BLOB AS supply_hk__product_hk,
    id AS supply_bk,
    sku AS product_bk,
    'jaffle shop' AS source,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data