model (
    name bronze.raw__jaffle_shop__supplies,
    kind view,
    audits (
        not_null(columns := id),
        not_null(columns := sku),
        unique_combination_of_columns(columns := (id, sku))
    )
);

select
    *

from
    read_csv('./jaffle-data/raw_supplies.csv', all_varchar=true, filename=true)
;