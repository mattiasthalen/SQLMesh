model (
    name silver.sat__tweet
);

select
    tweet_hk
,   tweet_pit_hk

,   tweeted_at
,   content

,   filename
,   source
,   valid_from
,   valid_to

from
    silver.stg__jaffle_shop__tweets
;