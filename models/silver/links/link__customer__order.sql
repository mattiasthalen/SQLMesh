model (
    name silver.link__customer__order
);

select
    customer_hk__order_hk
,   customer_hk
,   order_hk
,   source
,   min(valid_from) as valid_from
,   max(valid_to) as valid_to

from
    silver.stg__jaffle_shop__orders

group by
    customer_hk__order_hk
,   customer_hk
,   order_hk
,   source
;