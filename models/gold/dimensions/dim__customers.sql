model (
    name gold.dim__customers,
    cron '@hourly',
    kind full
);

select * from silver.sat__customer;