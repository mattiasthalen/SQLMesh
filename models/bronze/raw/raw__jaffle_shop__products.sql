model (
    name bronze.raw__jaffle_shop__products,
    kind view,
    columns (
        sku varchar,
        name varchar,
        type varchar,
        price varchar,
        description varchar,
        filename varchar
    ),
    audits (
        not_null(columns := sku),
        unique_values(columns := sku)
    )
);

select
    sku
,   name
,   type
,   price
,   description
,   filename

from
    read_csv('./jaffle-data/raw_products.csv', all_varchar=true, filename=true)
;