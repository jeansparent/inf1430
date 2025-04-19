#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 17 avril 2025

export PYTHON_BACKEND_SOURCE="CSV"
export PYTHON_BACKEND_CSV_PATH="/home/jsparent/repos/inf1430/SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv"
export PYTHON_BACKEND_POSTGRES_HOST='localhost'
export PYTHON_BACKEND_POSTGRES_DB='patent'
export PYTHON_BACKEND_POSTGRES_USER='postgres'
export PYTHON_BACKEND_POSTGRES_PASSWORD='Bonjour123!'


python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt