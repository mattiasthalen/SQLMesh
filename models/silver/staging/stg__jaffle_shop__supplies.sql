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
    id::BLOB AS id,
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
    'jaffle shop' AS source,
    @generate_surrogate_key__sha_256(source, id)::BLOB AS supply_hk,
    @generate_surrogate_key__sha_256(source, id, valid_from)::BLOB AS supply_pit_hk,
    @generate_surrogate_key__sha_256(source, sku)::BLOB AS product_hk,
    @generate_surrogate_key__sha_256(source, id, sku)::BLOB AS supply_hk__product_hk,
    id AS supply_bk,
    sku AS product_bk,
    *
  FROM casted_data
)
SELECT
  *
FROM final_data