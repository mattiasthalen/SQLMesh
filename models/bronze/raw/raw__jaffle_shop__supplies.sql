model (
    name bronze.raw__jaffle_shop__supplies,
    kind view
);

select
    *

from
    read_csv('./jaffle-data/raw_supplies.csv', all_varchar=true, filename=true)
;