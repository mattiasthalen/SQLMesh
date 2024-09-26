MODEL (
  name silver.hub__customer,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := customer_hk), NOT_NULL(columns := customer_hk))
);

WITH primary_source AS (
  SELECT
    customer_hk,
    customer_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__customers
  GROUP BY
    customer_hk,
    customer_bk,
    source_system,
    source_table
), secondary_source AS (
  SELECT
    customer_hk,
    customer_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__orders
  GROUP BY
    customer_hk,
    customer_bk,
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
    NOT customer_bk IN (
      SELECT
        customer_bk
      FROM primary_source
    )
)
SELECT
  *
FROM union_all