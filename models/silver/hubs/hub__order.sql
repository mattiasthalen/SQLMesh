MODEL (
  name silver.hub__order,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := order_hk), NOT_NULL(columns := order_hk))
);

WITH primary_source AS (
  SELECT
    order_hk,
    order_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__orders
  GROUP BY
    order_hk,
    order_bk,
    source_system,
    source_table
), secondary_source AS (
  SELECT
    order_hk,
    order_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__items
  GROUP BY
    order_hk,
    order_bk,
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
    NOT order_bk IN (
      SELECT
        order_bk
      FROM primary_source
    )
)
SELECT
  *
FROM union_all