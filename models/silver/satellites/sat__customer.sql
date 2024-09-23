model (
    name silver.sat__customer
);

select
    customer_hk
,   customer_pit_hk
,   source
,   id
,   name
,   filename
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__customers
;