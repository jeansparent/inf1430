#!/usr/bin/env python
# encoding: utf-8

import json
from flask import Flask, request, jsonify, Response
import pandas as pd
import os
import sys

backend_source = os.getenv('PYTHON_BACKEND_SOURCE')
csv_path = os.getenv('PYTHON_BACKEND_CSV_PATH')

def get_csv_data(path: str):
    df = pd.read_csv(path, sep="|", encoding='utf-8')
    return df

app = Flask(__name__)

@app.route('/CSV')
def get_csv():
    """Get CSV data with optional start/end query parameters"""
    if backend_source != "CSV":
        return jsonify({"error": "Unsupported backend source"}), 400

    CSV_records = get_csv_data(csv_path)

    start = request.args.get('start', default=0, type=int)
    end = request.args.get('end', default=None, type=int)

    sliced_df = CSV_records.iloc[start:end]

    records = sliced_df.to_dict(orient='records')

    return jsonify(records)

app.run(host='0.0.0.0')