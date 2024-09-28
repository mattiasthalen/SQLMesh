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
) -> pd.DataFrame:

    locations = {
        "Philadelphia": {"lat": "39.9526", "lon": "-75.1652"},
        "Brooklyn": {"lat": "40.6782", "lon": "-73.9442"},
        "Chicago": {"lat": "41.8781", "lon": "-87.6298"},
        "San Francisco": {"lat": "37.7749", "lon": "-122.4194"},
        "New Orleans": {"lat": "29.9511", "lon": "-90.0715"},
        "Los Angeles": {"lat": "34.0522", "lon": "-118.2437"}
    }

    url = "https://meteostat.p.rapidapi.com/point/daily"

    headers = {
        "x-rapidapi-key": "2a32a64ef2msh9d4940a2cc62450p1444cajsn98ae2e640027",
        "x-rapidapi-host": "meteostat.p.rapidapi.com"
    }

    final_df = pd.DataFrame()

    for city, coords in locations.items():
        querystring = {
            "lat": coords["lat"],
            "lon": coords["lon"],
            "start": start.strftime('%Y-%m-%d'),
            "end": end.strftime('%Y-%m-%d')
        }

        response = requests.get(url, headers=headers, params=querystring)
        data = response.json()

        df = pd.DataFrame(data['data'])
        df['city'] = city
        df['lat'] = coords["lat"]
        df['lon'] = coords["lon"]

        final_df = pd.concat([final_df, df], ignore_index=True)

    return final_df