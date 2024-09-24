model (
    name gold.dim__stores,
    cron '@hourly',
    kind full
);

select * from silver.sat__store;