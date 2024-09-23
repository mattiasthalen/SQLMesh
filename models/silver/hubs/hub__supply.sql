model (
    name silver.hub__supply
);

select
    supply_hk
,   supply_bk
,   source
,   min(valid_from) as load_date

from
    silver.stg__jaffle_shop__supplies

group by
    supply_hk
,   supply_bk
,   source
;