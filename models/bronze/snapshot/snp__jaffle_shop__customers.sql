model (
    name bronze.snp__jaffle_shop__customers,
    cron '*/5 * * * *',
    kind scd_type_2_by_column (
        unique_key id,
        columns *
    )
);

select * from bronze.raw__jaffle_shop__customers;