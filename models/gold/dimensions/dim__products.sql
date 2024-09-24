model (
    name gold.dim__products,
    cron '@hourly',
    kind full
);

select * from silver.sat__product;