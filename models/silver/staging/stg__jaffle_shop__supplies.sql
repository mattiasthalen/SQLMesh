model (
    name silver.stg__jaffle_shop__supplies,
    kind view
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__supplies
        )

,   casted_data as
        (
            select
                id::uuid as id
            ,   name::text as name
            ,   cost::numeric as cost
            ,   perishable::boolean as perishable
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
                @generate_surrogate_key__sha_256(id)::blob as supply_hk
            ,   @generate_surrogate_key__sha_256(id, valid_from)::blob as supply_pit_hk
            ,   @generate_surrogate_key__sha_256(sku)::blob as product_hk
            ,   @generate_surrogate_key__sha_256(id, sku)::blob as supply_hk__product_hk
            ,   id as supply_bk
            ,   sku as product_bk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;