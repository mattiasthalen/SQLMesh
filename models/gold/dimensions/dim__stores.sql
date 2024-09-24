model (
    name gold.dim__stores,
    cron '@hourly',
    kind view
);

select * from silver.sat__store;