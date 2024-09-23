model (
    name silver.sat__supply,
    kind view
);

select
    supply_hk
,   supply_pit_hk

,   id
,   name
,   cost
,   perishable

,   filename
,   source
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__supplies
;