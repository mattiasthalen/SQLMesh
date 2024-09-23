model (
    name bronze.raw__jaffle_shop__items,
    kind view,
    audits (
        not_null(columns := id),
        unique_values(columns := id)
    )
);

select
    *

from
    read_csv('./jaffle-data/raw_items.csv', all_varchar=true, filename=true)
;