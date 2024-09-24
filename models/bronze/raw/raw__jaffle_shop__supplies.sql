model (
    name bronze.raw__jaffle_shop__supplies,
    kind view,
    columns (
        id varchar,
        name varchar,
        cost varchar,
        perishable varchar,
        sku varchar,
        filename varchar
    ),
    audits (
        not_null(columns := id),
        not_null(columns := sku),
        unique_combination_of_columns(columns := (id, sku))
    )
);

select
    id
,   name
,   cost
,   perishable
,   sku
,   filename

from
    read_csv('./jaffle-data/raw_supplies.csv', all_varchar=true, filename=true)
;