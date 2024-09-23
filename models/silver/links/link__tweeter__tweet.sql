model (
    name silver.link__tweeter__tweet
);

select
    tweeter_hk__tweet_hk
,   tweeter_hk
,   tweet_hk
,   source
,   min(valid_from) as valid_from
,   max(valid_to) as valid_to

from
    silver.stg__jaffle_shop__tweets

group by
    tweeter_hk__tweet_hk
,   tweeter_hk
,   tweet_hk
,   source
;