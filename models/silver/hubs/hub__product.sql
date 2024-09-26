MODEL (
  name silver.hub__product,
  kind VIEW,
  audits (UNIQUE_VALUES(columns := product_hk), NOT_NULL(columns := product_hk))
);

WITH primary_source AS (
  SELECT
    product_hk,
    product_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__products
  GROUP BY
    product_hk,
    product_bk,
    source_system,
    source_table
), secondary_source AS (
  SELECT
    product_hk,
    product_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__items
  GROUP BY
    product_hk,
    product_bk,
    source_system,
    source_table
), tertiary_source AS (
  SELECT
    product_hk,
    product_bk,
    source_system,
    source_table,
    MIN(valid_from) AS valid_from
  FROM silver.stg__jaffle_shop__supplies
  GROUP BY
    product_hk,
    product_bk,
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
    NOT product_bk IN (
      SELECT
        product_bk
      FROM primary_source
    )
  UNION ALL
  SELECT
    *
  FROM tertiary_source
  WHERE
    NOT product_bk IN (
      SELECT
        product_bk
      FROM primary_source
    )
    AND NOT product_bk IN (
      SELECT
        product_bk
      FROM secondary_source
    )
)
SELECT
  *
FROM union_all