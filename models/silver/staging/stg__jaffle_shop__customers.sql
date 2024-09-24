model (
    name silver.stg__jaffle_shop__customers,
    kind view
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__customers
        )

,   casted_data as
        (
            select
                id::uuid as id
            ,   name::varchar as name
            ,   filename::varchar as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key(id)::uuid as customer_hk
            ,   @generate_surrogate_key(id, valid_from)::uuid as customer_pit_hk
            ,   name as customer_bk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;