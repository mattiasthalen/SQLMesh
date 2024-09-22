model (
    name bronze.snp__jaffle_shop__products,
    kind scd_type_2_by_column (
        unique_key sku,
        columns *
    )
);

select * from bronze.raw__jaffle_shop__products;