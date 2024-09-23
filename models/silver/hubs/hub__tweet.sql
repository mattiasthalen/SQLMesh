model (
    name silver.hub__tweet
);

select
    tweet_hk
,   tweet_bk
,   source
,   min(valid_from) as load_date

from
    silver.stg__jaffle_shop__tweets

group by
    tweet_hk
,   tweet_bk
,   source
;