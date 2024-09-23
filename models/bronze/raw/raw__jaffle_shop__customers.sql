model (
    name bronze.raw__jaffle_shop__customers,
    kind view,
    audits (
        not_null(columns := (id))
    )
);

select
    *

from
    read_csv('./jaffle-data/raw_customers.csv', all_varchar=true, filename=true)
;