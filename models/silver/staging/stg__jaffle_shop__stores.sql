MODEL (
  name silver.stg__jaffle_shop__stores,
  kind VIEW,
  grain store_pit_hk,
  references store_hk,
  audits (UNIQUE_VALUES(columns := store_pit_hk), NOT_NULL(columns := store_pit_hk))
);

WITH source_data AS (
  SELECT
    *
  FROM bronze.snp__jaffle_shop__stores
), casted_data AS (
  SELECT
    id::BLOB AS id,
    name::TEXT AS name,
    opened_at::TIMESTAMP AS opened_at,
    tax_rate::DECIMAL(18, 3) AS tax_rate,
    filename::TEXT AS filename,
    valid_from::TIMESTAMP AS valid_from,
    COALESCE(valid_to::TIMESTAMP, '9999-12-31 23:59:59'::TIMESTAMP) AS valid_to
  FROM source_data
), data_vault AS (
  SELECT
    'jaffle_shop' AS source_system,
    'raw_stores' AS source_table,
    CONCAT(source_system, '|', id) AS store_bk,
    name AS city_bk,
    *
  FROM casted_data
), final_data AS (
  SELECT
    @generate_surrogate_key__sha_256(store_bk) AS store_hk,
    @generate_surrogate_key__sha_256(store_bk, valid_from) AS store_pit_hk,
    @generate_surrogate_key__sha_256(city_bk) AS city_hk,
    @generate_surrogate_key__sha_256(store_bk, city_bk) AS store_hk__city__hk,
    *
  FROM data_vault
)
SELECT
  *
FROM final_data