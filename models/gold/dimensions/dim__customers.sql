model (
    name gold.dim__customers,
    kind incremental_by_time_range(
        time_column valid_from
    )
);

select
    *

from
    silver.sat__customer

where
    sat__customer.valid_from between @start_ts and @end_ts
;