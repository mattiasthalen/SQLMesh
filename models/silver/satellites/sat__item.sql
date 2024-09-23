model (
    name silver.sat__item,
    kind view
);

select
    order_hk__product_hk
,   item_hk
,   item_pit_hk
,   quantity
,   source
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__items
;