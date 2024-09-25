model (
    name silver.stg__jaffle_shop__products,
    kind view
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__products
        )

,   casted_data as
        (
            select
                sku::text as sku
            ,   name::text as name
            ,   type::text as type
            ,   price::int as price
            ,   description::text as description
            ,   filename::text as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key__sha_256(sku)::blob as product_hk
            ,   @generate_surrogate_key__sha_256(sku, valid_from)::blob as product_pit_hk
            ,   sku as product_bk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;