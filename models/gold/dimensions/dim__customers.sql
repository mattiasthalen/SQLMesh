model (
    name gold.dim__customers,
    cron '@hourly',
    kind view
);

select * from silver.sat__customer;