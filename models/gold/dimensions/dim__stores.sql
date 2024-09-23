model (
    name gold.dim__stores,
    kind incremental_by_time_range(
        time_column valid_from
    )
);

select
    *

from
    silver.sat__store
    
where
    sat__store.valid_from between @start_ts and @end_ts
;