model (
    name silver.sat__order
);

select
    order_hk
,   order_pit_hk
,   id
,   ordered_at
,   subtotal
,   tax_paid
,   order_total
,   filename
,   source
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__orders
;