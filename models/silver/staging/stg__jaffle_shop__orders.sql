model (
    name silver.stg__jaffle_shop__orders
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__orders
        )

,   casted_data as
        (
            select
                id::uuid as id
            ,   customer::uuid as customer_id
            ,   ordered_at::timestamp as ordered_at
            ,   store_id::uuid as store_id
            ,   subtotal::int as subtotal
            ,   tax_paid::int as tax_paid
            ,   order_total::int as order_total
            ,   filename::varchar as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key(id) as order_hk
                @generate_surrogate_key(id, valid_from) as order_pit_hk
            ,   @generate_surrogate_key(customer_id) as customer_hk
            ,   @generate_surrogate_key(store_id) as store_hk
            ,   @generate_surrogate_key(id, store_id) as order_hk__store_hk
            ,   @generate_surrogate_key(customer_id, id) as customer_hk__order_hk
            ,   id as order_bk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;