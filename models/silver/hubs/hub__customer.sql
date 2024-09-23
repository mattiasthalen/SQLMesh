model (
    name silver.hub__customer
);

select
    customer_hk
,   customer_bk
,   source
,   min(valid_from) as load_date

from
    silver.stg__jaffle_shop__customers

group by
    customer_hk
,   customer_bk
,   source
;