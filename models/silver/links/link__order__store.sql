model (
    name silver.link__order__store
);

select
    order_hk__store_hk
,   order_hk
,   store_hk
,   source
,   min(valid_from) as valid_from
,   max(coalesce(valid_to, '9999-12-31 23:59:59'::timestamp)) as valid_to

from
    silver.stg__jaffle_shop__orders

group by
    order_hk__store_hk
,   order_hk
,   store_hk
,   source
;