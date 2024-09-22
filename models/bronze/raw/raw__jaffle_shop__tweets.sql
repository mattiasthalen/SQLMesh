model (
    name bronze.raw__jaffle_shop__tweets,
    kind view
);

select
    *
,   current_timestamp as extracted_at

from
    read_csv('./jaffle-data/raw_tweets.csv', all_varchar=true, filename=true)
;