#!/bin/bash

# Remove existing virtual environment if it exists
if [ -d ".venv" ]; then
  rm -rf .venv
fi

# Create a new virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Install pre-commit hooks
pre-commit install

# Export environment variables from .env file
source export_env_vars.sh

echo "Environment setup complete!"