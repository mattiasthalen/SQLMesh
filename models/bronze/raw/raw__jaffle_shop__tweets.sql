model (
    name bronze.raw__jaffle_shop__tweets,
    kind view,
    audits (
        not_null(columns := (id))
    )
);

select
    *

from
    read_csv('./jaffle-data/raw_tweets.csv', all_varchar=true, filename=true)
;