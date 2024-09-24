model (
    name bronze.raw__jaffle_shop__tweets,
    kind view,
    columns (
        id varchar,
        user_id varchar,
        tweeted_at varchar,
        content varchar,
        filename varchar
    ),
    audits (
        not_null(columns := id),
        unique_values(columns := id)
    )
);

select
    id
,   user_id
,   tweeted_at
,   content
,   filename

from
    read_csv('./jaffle-data/raw_tweets.csv', all_varchar=true, filename=true)
;