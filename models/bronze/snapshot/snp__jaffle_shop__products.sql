model (
    name bronze.snp__jaffle_shop__products,
    kind scd_type_2_by_column (
        unique_key sku,
        columns *,
        execution_time_as_valid_from true
    )
);

select * from bronze.raw__jaffle_shop__products;