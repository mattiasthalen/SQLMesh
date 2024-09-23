model (
    name silver.hub__order
);

select
    order_hk
,   order_bk
,   source
,   min(valid_from) as valid_from

from
    silver.stg__jaffle_shop__orders

group by
    order_hk
,   order_bk
,   source
;