#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 16 avril 2025

export PYTHON_FRONTEND_SOURCE="CSV"
export PYTHON_FRONTEND_CSV_PATH="/home/jsparent/repos/inf1430/SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv"
export PYTHON_FRONTEND_RECORDS_PER_PAGE=1000
export PYTHON_FRONTEND_API_URL="http://192.168.18.250:5000"

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt