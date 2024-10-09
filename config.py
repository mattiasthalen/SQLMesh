import os

from dotenv import load_dotenv, set_key
from pathlib import Path
from sqlmesh.core.config import (
    Config,
    ModelDefaultsConfig,
    GatewayConfig,
    DuckDBConnectionConfig,
    NameInferenceConfig
)


# Define the path to your .env file
env_file = Path('.env')

# Load existing environment variables from the .env file
if env_file.exists():
    load_dotenv(dotenv_path=env_file)

# Try to get the specific environment variable from the loaded .env file or os environment
default_environment = os.getenv('DEFAULT_ENVIRONMENT')

# If the environment variable is not set, prompt the user for input
if not default_environment:
    while True:
        default_environment = input("Please enter the environment (e.g., dev__developer_name): ").strip()
        if default_environment:
            # Set it for the current process
            os.environ['DEFAULT_ENVIRONMENT'] = default_environment
            # Persist the environment variable to the .env file
            set_key(env_file, 'DEFAULT_ENVIRONMENT', default_environment)
            break  # Exit the loop if input is not blank
        else:
            print("Environment cannot be blank. Please try again.")

print(f"Environment is set to: {default_environment}.")

config = Config(
    project="jaffle_shop",
    default_target_environment=default_environment,
    gateways={
        "local": GatewayConfig(
            connection=DuckDBConnectionConfig(
                database="warehouse.duckdb"
            )
        )
    },
    default_gateway="local",
    model_defaults=ModelDefaultsConfig(
        dialect="duckdb",
        start="2018-01-01"
    ),
    model_naming=NameInferenceConfig(
        infer_names=True
    )
)