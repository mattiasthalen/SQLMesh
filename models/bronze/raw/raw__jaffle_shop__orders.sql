model (
    name bronze.raw__jaffle_shop__orders,
    kind view
);

select
    *

from
    read_csv('./jaffle-data/raw_orders.csv', all_varchar=true, filename=true)
;