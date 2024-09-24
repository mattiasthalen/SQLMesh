model (
    name bronze.raw__jaffle_shop__items,
    kind view,
    columns (
        id varchar,
        order_id varchar,
        sku varchar,
        filename varchar
    ),
    audits (
        not_null(columns := id),
        unique_values(columns := id)
    )
);

select
    id
,   order_id
,   sku
,   filename

from
    read_csv('./jaffle-data/raw_items.csv', all_varchar=true, filename=true)
;