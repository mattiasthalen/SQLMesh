model (
    name silver.sat__supply
);

select
    supply_hk

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