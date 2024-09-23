model (
    name silver.link__order__product
);

select
    order_hk__product_hk
,   order_hk
,   product_hk
,   source
,   min(valid_from) as valid_from
,   max(valid_to) as valid_to

from
    silver.stg__jaffle_shop__items

group by
    order_hk__product_hk
,   order_hk
,   product_hk
,   source
;