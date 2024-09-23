model (
    name silver.hub__store
);

select
    store_hk
,   store_bk
,   source
,   min(valid_from) as load_date

from
    silver.stg__jaffle_shop__stores

group by
    store_hk
,   store_bk
,   source
;