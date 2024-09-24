model (
    name gold.dim__products,
    cron '@hourly',
    kind view
);

select * from silver.sat__product;