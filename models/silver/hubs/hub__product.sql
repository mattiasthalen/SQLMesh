model (
    name silver.hub__product
);

select
    product_hk
,   product_bk
,   source
,   min(valid_from) as valid_from

from
    silver.stg__jaffle_shop__products

group by
    product_hk
,   product_bk
,   source
;