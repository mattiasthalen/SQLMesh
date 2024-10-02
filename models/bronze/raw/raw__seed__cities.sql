MODEL (
  name bronze.raw__seed__cities,
  cron '@daily',
  kind SEED (
    path '$root/seeds/cities.csv'
  ),
  columns (
    city TEXT,
    latitude TEXT,
    longitude TEXT
  )
)