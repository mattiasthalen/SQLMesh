model (
    name silver.sat__product,
    kind view
);

select
    product_hk
,   product_pit_hk

,   sku
,   name
,   type
,   price
,   description

,   filename
,   source
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__products
;