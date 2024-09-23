model (
    name silver.link__order__store
);

select
    order_hk__store_hk
,   order_hk
,   store_hk
,   source
,   min(valid_from) as valid_from
,   max(valid_to) as valid_to

from
    silver.stg__jaffle_shop__orders

group by
    order_hk__store_hk
,   order_hk
,   store_hk
,   source
;