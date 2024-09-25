model (
    name silver.stg__jaffle_shop__items,
    kind view
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
            ,   sku::text as sku
            ,   filename::text as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key__sha_256(id)::blob as item_hk
            ,   @generate_surrogate_key__sha_256(id, valid_from)::blob as item_pit_hk
            ,   @generate_surrogate_key__sha_256(order_id)::blob as order_hk
            ,   @generate_surrogate_key__sha_256(sku)::blob as product_hk
            ,   @generate_surrogate_key__sha_256(order_id, sku)::blob as order_hk__product_hk
            ,   'jaffle shop' as source
            ,   1 as quantity
            ,   *

            from
                casted_data
        )

select * from final_data;