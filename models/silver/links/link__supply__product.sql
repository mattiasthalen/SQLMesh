model (
    name silver.link__supply__product
);

select
    supply_hk__product_hk
,   supply_hk
,   product_hk
,   source
,   min(valid_from) as valid_from
,   max(coalesce(valid_to, '9999-12-31 23:59:59'::timestamp)) as valid_to

from
    silver.stg__jaffle_shop__supplies

group by
    supply_hk__product_hk
,   supply_hk
,   product_hk
,   source
;