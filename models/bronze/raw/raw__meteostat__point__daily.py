import pandas as pd
import typing as t
import requests

from datetime import datetime
from sqlmesh import ExecutionContext, model
from sqlmesh.core.model.kind import ModelKindName

@model(
    "bronze.raw__meteostat__point__daily",
    kind="full",
    columns={
        "city": "text",
        "lat": "text",
        "lon": "text",
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
) -> pd.DataFrame | None:

    locations = {
        "Philadelphia": {"lat": "39.9526", "lon": "-75.1652"},
        "Brooklyn": {"lat": "40.6782", "lon": "-73.9442"},
        "Chicago": {"lat": "41.8781", "lon": "-87.6298"},
        "San Francisco": {"lat": "37.7749", "lon": "-122.4194"},
        "New Orleans": {"lat": "29.9511", "lon": "-90.0715"},
        "Los Angeles": {"lat": "34.0522", "lon": "-118.2437"}
    }

    locations_df = pd.DataFrame.from_dict(locations, orient='index').reset_index()
    locations_df.columns = ['city', 'lat', 'lon']

    url = "https://meteostat.p.rapidapi.com/point/daily"

    headers = {
        "x-rapidapi-key": "2a32a64ef2msh9d4940a2cc62450p1444cajsn98ae2e640027",
        "x-rapidapi-host": "meteostat.p.rapidapi.com"
    }

    all_data = []

    for _, row in locations_df.iterrows():
        querystring = {
            "lat": row['lat'],
            "lon": row['lon'],
            "start": start.strftime('%Y-%m-%d'),
            "end": end.strftime('%Y-%m-%d')
        }

        response = requests.get(url, headers=headers, params=querystring)
        if response.status_code != 200:
            print(f"Failed to fetch data for {row['city']}, status code: {response.status_code}")
            continue

        data = response.json()
        if 'data' not in data:
            print(f"No data found for {row['city']}")
            continue

        df = pd.DataFrame(data['data'])
        if df.empty:
            print(f"No data available for {row['city']}")
            continue

        df['city'] = row['city']
        all_data.append(df)

    all_data__filtered = [df for df in all_data if not df.empty]

    if not all_data__filtered:
        return None
    
    weather_df = pd.concat(all_data__filtered, ignore_index=True)
    final_df = locations_df.merge(weather_df, on='city', how='left')

    return final_df