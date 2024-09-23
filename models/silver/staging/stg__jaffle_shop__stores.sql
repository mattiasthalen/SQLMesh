model (
    name silver.stg__jaffle_shop__stores
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__stores
        )

,   casted_data as
        (
            select
                id::uuid as id
            ,   name::varchar as name
            ,   opened_at::timestamp as opened_at
            ,   tax_rate::numeric as tax_rate
            ,   filename::varchar as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key(id) as store_hk
            ,   id as store_bk
            ,   *

            from
                casted_data
        )

select * from final_data;