model (
    name silver.hub__store,
    kind view
);

select
    store_hk
,   store_bk
,   source
,   min(valid_from) as valid_from

from
    silver.stg__jaffle_shop__stores

group by
    store_hk
,   store_bk
,   source
;