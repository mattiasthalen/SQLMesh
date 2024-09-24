model (
    name bronze.raw__jaffle_shop__stores,
    kind view,
    columns (
        id varchar,
        name varchar,
        opened_at varchar,
        tax_rate varchar,
        filename varchar
    ),
    audits (
        not_null(columns := id),
        unique_values(columns := id)
    )
);

select
    id
,   name
,   opened_at
,   tax_rate
,   filename

from
    read_csv('./jaffle-data/raw_stores.csv', all_varchar=true, filename=true)
;