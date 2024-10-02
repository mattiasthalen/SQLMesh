MODEL (
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