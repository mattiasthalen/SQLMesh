model (
    name silver.link__customer__order
);

select
    customer_hk__order_hk
,   customer_hk
,   order_hk
,   source
,   min(valid_from) as valid_from
,   max(coalesce(valid_to, '9999-12-31 23:59:59'::timestamp)) as valid_to

from
    silver.stg__jaffle_shop__orders

group by
    customer_hk__order_hk
,   customer_hk
,   order_hk
,   source
;