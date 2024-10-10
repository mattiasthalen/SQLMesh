#!/bin/bash

# Check if Python 3.12 is available
if ! command -v python3.12 &> /dev/null
then
    echo "Error: Python 3.12 is not installed or not available in the system's PATH."
    exit 1
fi

# Remove existing virtual environment if it exists
if [ -d ".venv" ]; then
  rm -rf .venv
fi

# Create a new virtual environment
python3.12 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Install pre-commit hooks
pre-commit install

# Export environment variables from .env file
source export_env_vars.sh

echo "Environment setup complete!"