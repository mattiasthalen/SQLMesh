MODEL (
  name silver.hub__store,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := store_hk), NOT_NULL(columns := store_hk))
);

WITH primary_source AS (
  SELECT
    store_hk,
    store_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__stores
  GROUP BY
    store_hk,
    store_bk,
    source_system,
    source_table
), secondary_source AS (
  SELECT
    store_hk,
    store_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__orders
  GROUP BY
    store_hk,
    store_bk,
    source_system,
    source_table
), union_all AS (
  SELECT
    *
  FROM primary_source
  UNION ALL
  SELECT
    *
  FROM secondary_source
  WHERE
    NOT store_bk IN (
      SELECT
        store_bk
      FROM primary_source
    )
)
SELECT
  *
FROM union_all