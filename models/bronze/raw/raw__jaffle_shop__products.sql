model (
    name bronze.raw__jaffle_shop__products,
    kind view,
    audits (
        not_null(columns := (sku))
    )
);

select
    *

from
    read_csv('./jaffle-data/raw_products.csv', all_varchar=true, filename=true)
;