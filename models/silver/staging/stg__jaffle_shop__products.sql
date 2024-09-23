model (
    name silver.stg__jaffle_shop__products
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__products
        )

,   casted_data as
        (
            select
                sku::varchar as sku
            ,   name::varchar as name
            ,   type::varchar as type
            ,   price::int as price
            ,   description::varchar as description
            ,   filename::varchar as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key(sku) as product_hk
                @generate_surrogate_key(sku, valid_from) as product_pit_hk
            ,   sku as product_bk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;