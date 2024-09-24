model (
    name gold.dim__stores,
    cron '@hourly',
    kind view
);

select * from silver.sat__store;

@if(
  @runtime_stage = 'evaluating',
  copy gold.dim__stores to 'exports/gold.dim__stores.parquet' (format parquet)
);