import pandas as pd
import typing as t
import requests
import time
import os

from datetime import datetime
from sqlmesh import ExecutionContext, model
from sqlmesh.core.model.kind import ModelKindName

@model(
    cron="@daily",
    kind=dict(
        name=ModelKindName.INCREMENTAL_BY_TIME_RANGE,
        time_column="date"
    ),
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
)

def execute(
    context: ExecutionContext,
    start: datetime,
    end: datetime,
    execution_time: datetime,
    **kwargs: t.Any,
) -> t.Generator[pd.DataFrame, None, None]:
    
    # no_data = yield from ()
    # return no_data
    
    raw__seed__cities = context.table("bronze.raw__seed__cities")
    raw__seed__cities__df = context.fetchdf(f"SELECT * FROM {raw__seed__cities}")
    
    url = "https://meteostat.p.rapidapi.com/point/daily"

    headers = {
        "x-rapidapi-key": os.getenv('X_RAPIDAPI_KEY'),
        "x-rapidapi-host": "meteostat.p.rapidapi.com"
    }

    all_data = []

    for _, row in raw__seed__cities__df.iterrows():
        querystring = {
            "lat": row['latitude'],
            "lon": row['longitude'],
            "start": start.strftime('%Y-%m-%d'),
            "end": end.strftime('%Y-%m-%d')
        }

        for attempt in range(5):
            response = requests.get(url, headers=headers, params=querystring)
            if response.status_code == 200:
                break
            elif response.status_code == 429:
                sleep_duration = 1
                print(f"Rate limit exceeded. Retrying in {sleep_duration} seconds...")
                time.sleep(sleep_duration)
            else:
                print(f"Error fetching data for {row['city']}: {response.status_code}")
                break

        if response.status_code != 200:
            continue

        data = response.json()
        if 'data' not in data:
            print(f"No data found for {row['city']}")
            continue

        df = pd.DataFrame(data['data'])

        df['latitude'] = row['latitude']
        df['longitude'] = row['longitude']

        print(f"{row['city']}: {len(df)}")

        all_data.append(df.astype(str))

    final_df = pd.concat(all_data, ignore_index=True)

    return final_df