model (
    name silver.sat__store
);

select
    store_hk
,   store_pit_hk

,   id
,   name
,   opened_at
,   tax_rate

,   filename
,   source
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__stores
;