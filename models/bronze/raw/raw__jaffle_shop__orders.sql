model (
    name bronze.raw__jaffle_shop__orders,
    kind view,
    audits (
        not_null(columns := (id))
    )
);

select
    *

from
    read_csv('./jaffle-data/raw_orders.csv', all_varchar=true, filename=true)
;