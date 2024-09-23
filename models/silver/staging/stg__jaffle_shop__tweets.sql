model (
    name silver.stg__jaffle_shop__tweets,
    kind view
);

with
    source_data as
        (
            select * from bronze.snp__jaffle_shop__tweets
        )

,   casted_data as
        (
            select
                id::uuid as id
            ,   user_id::uuid as user_id
            ,   tweeted_at::timestamp as tweeted_at
            ,   content::varchar as content
            ,   filename::varchar as filename
            ,   valid_from::timestamp as valid_from
            ,   coalesce(valid_to::timestamp, '9999-12-31 23:59:59'::timestamp) as valid_to

            from
                source_data

        )

,   final_data as
        (
            select
                @generate_surrogate_key(user_id) as tweeter_hk
            ,   @generate_surrogate_key(id) as tweet_hk
            ,   @generate_surrogate_key(id, valid_from) as tweet_pit_hk
            ,   @generate_surrogate_key(user_id,id) as tweeter_hk__tweet_hk
            ,   user_id as tweeter_bk
            ,   id as tweet_bk
            ,   'jaffle shop' as source
            ,   *

            from
                casted_data
        )

select * from final_data;