model (
    name gold.dim__products,
    kind incremental_by_time_range(
        time_column valid_from
    )
);

select * from silver.sat__product;