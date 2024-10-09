import pandas as pd
import typing as t
import requests
import time
import os

from dotenv import load_dotenv, set_key
from pathlib import Path

from datetime import datetime
from sqlmesh import ExecutionContext, model
from sqlmesh.core.model.kind import ModelKindName

# Define the path to your .env file
env_file = Path('.env')
env_var = 'X_RAPIDAPI_KEY'

# Load existing environment variables from the .env file
if env_file.exists():
    load_dotenv(dotenv_path=env_file)

# Try to get the specific environment variable from the loaded .env file or os environment
x_rapidapi_key = os.getenv(env_var)

# If the environment variable is not set, prompt the user for input
if not x_rapidapi_key:
    while True:
        default_environment = input("Please enter the API key for rapid api: ").strip()
        if x_rapidapi_key:
            # Set it for the current process
            os.environ[env_var] = x_rapidapi_key
            # Persist the environment variable to the .env file
            set_key(env_file, env_var, x_rapidapi_key)
            break  # Exit the loop if input is not blank
        else:
            print("API key cannot be blank. Please try again.")

print(f"API key is set to: {x_rapidapi_key}.")

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
        "x-rapidapi-key": x_rapidapi_key,
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