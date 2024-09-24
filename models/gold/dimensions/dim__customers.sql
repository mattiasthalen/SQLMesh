model (
    name gold.dim__customers,
    cron '@hourly',
    kind view,
    grain customer_pit_hk
);

select * from silver.sat__customer;

@if(
  @runtime_stage = 'evaluating',
  copy gold.dim__customers to 'exports/gold.dim__customers.parquet' (format parquet)
);