model (
    name bronze.raw__jaffle_shop__stores,
    kind view,
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