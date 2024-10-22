import pandas as pd
import typing as t
import requests
import time
import os

from datetime import datetime
from sqlmesh import ExecutionContext, model
from sqlmesh.core.model.kind import ModelKindName

columns={
      "latitude": "text",
      "longitude": "text",
      "date": "text",
      "tavg": "text",
      "tmin": "text",
      "tmax": "text",
      "prcp": "text",
      "snow": "text",
      "wdir": "text",
      "wspd": "text",
      "wpgt": "text",
      "pres": "text",
      "tsun": "text"
  }

@model(
    cron="@daily",
    kind=dict(
        name=ModelKindName.INCREMENTAL_BY_TIME_RANGE,
        time_column="date"
    ),
    columns=columns
)

def execute(
    context: ExecutionContext,
    start: datetime,
    end: datetime,
    execution_time: datetime,
    **kwargs: t.Any,
) -> t.Generator[pd.DataFrame, None, None]:
    
    raw__seed__cities = context.table("bronze.raw__seed__cities")
    raw__seed__cities__df = context.fetchdf(f"SELECT * FROM {raw__seed__cities}")
    
    url = "https://meteostat.p.rapidapi.com/point/daily"

    headers = {
        "x-rapidapi-key": os.getenv('X_RAPIDAPI_KEY'),
        "x-rapidapi-host": "meteostat.p.rapidapi.com"
    }

    final_df = pd.DataFrame({column: pd.Series(dtype='str') for column, data_type in columns.items()})

    for _, row in raw__seed__cities__df.iterrows():
        querystring = {
            "lat": row['latitude'],
            "lon": row['longitude'],
            "start": start.strftime('%Y-%m-%d'),
            "end": end.strftime('%Y-%m-%d')
        }

        response = None
        success = False
        n_attempts = 3
        
        for attempt in range(n_attempts):
            response = requests.get(url, headers=headers, params=querystring)
            if response.status_code == 200:
                success = True
                break
            elif response.status_code == 429:
                sleep_duration = 1
                print(f"Rate limit exceeded. Retrying in {sleep_duration} seconds...")
                time.sleep(sleep_duration)
            else:
                print(f"Error fetching data for {row['city']}: {response.status_code}")
                break
        
        if not success:
            print(f"Failed to fetch data for {row['city']} after {n_attempts} attempts")
            continue
        
        data = response.json() if response else {}
        
        if 'data' not in data:
            print(f"No 'data' key found in response for {row['city']}. Response: {data}")
            continue

        df = pd.DataFrame(data['data'])

        df['latitude'] = row['latitude']
        df['longitude'] = row['longitude']

        print(f"{row['city']}: {len(df)}")

        final_df = pd.concat([final_df, df.astype(str)], ignore_index=True)

    n_rows = len(final_df)
    
    print(f"Yielding DataFrame with {n_rows} rows.")

    if n_rows > 0:
        yield final_df
    else:
        yield from ()