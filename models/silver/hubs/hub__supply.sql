model (
    name silver.hub__supply,
    kind view
);

select
    supply_hk
,   supply_bk
,   source
,   min(valid_from) as valid_from

from
    silver.stg__jaffle_shop__supplies

group by
    supply_hk
,   supply_bk
,   source
;