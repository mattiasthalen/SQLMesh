model (
    name bronze.raw__jaffle_shop__stores,
    kind view
);

select
    *

from
    read_csv('./jaffle-data/raw_stores.csv', all_varchar=true, filename=true)
;