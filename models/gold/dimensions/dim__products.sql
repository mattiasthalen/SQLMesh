model (
    name gold.dim__products,
    cron '@hourly',
    kind full,
    grain product_pit_hk
);

select * from silver.sat__product;

@if(
  @runtime_stage = 'evaluating',
  copy gold.dim__products to 'exports/gold.dim__products.parquet' (format parquet)
);