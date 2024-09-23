model (
    name silver.link__tweeter__tweet
);

select
    tweeter_hk__tweet_hk
,   tweeter_hk
,   tweet_hk
,   source
,   min(valid_from) as valid_from
,   max(coalesce(valid_to, '9999-12-31 23:59:59'::timestamp)) as valid_to

from
    silver.stg__jaffle_shop__tweets

group by
    tweeter_hk__tweet_hk
,   tweeter_hk
,   tweet_hk
,   source
;