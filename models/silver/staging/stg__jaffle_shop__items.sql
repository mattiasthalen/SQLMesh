model (
    name silver.stg__jaffle_shop__items
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__items
        )

,   casted_data as
        (
            select
                id::uuid as id
            ,   order_id::uuid as order_id
            ,   sku::varchar as sku
            ,   filename::varchar as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key(id) as item_hk
            ,   @generate_surrogate_key(order_id) as order_hk
            ,   @generate_surrogate_key(sku) as product_hk
            ,   @generate_surrogate_key(order_id, sku) as order_hk__product_hk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;