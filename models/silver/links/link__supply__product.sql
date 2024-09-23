model (
    name silver.link__supply__product
);

select
    supply_hk__product_hk
,   supply_hk
,   product_hk
,   source
,   min(valid_from) as valid_from
,   max(valid_to) as valid_to

from
    silver.stg__jaffle_shop__supplies

group by
    supply_hk__product_hk
,   supply_hk
,   product_hk
,   source
;