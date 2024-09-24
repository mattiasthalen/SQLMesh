model (
    name bronze.raw__jaffle_shop__orders,
    kind view,
    columns (
        id varchar,
        customer varchar,
        ordered_at varchar,
        store_id varchar,
        subtotal varchar,
        tax_paid varchar,
        order_total varchar,
        filename varchar
    ),
    audits (
        not_null(columns := id),
        unique_values(columns := id)
    )
);

select
    id
,   customer
,   ordered_at
,   store_id
,   subtotal
,   tax_paid
,   order_total
,   filename 

from
    read_csv('./jaffle-data/raw_orders.csv', all_varchar=true, filename=true)
;