model (
    name silver.hub__customer,
    kind view
);

select
    customer_hk
,   customer_bk
,   source
,   min(valid_from) as valid_from

from
    silver.stg__jaffle_shop__customers

group by
    customer_hk
,   customer_bk
,   source
;