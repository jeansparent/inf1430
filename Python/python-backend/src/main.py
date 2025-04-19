#!/usr/bin/env python
# encoding: utf-8

# Auteur : Jean-Sébastien Parent
# Date: 19 avril 2025

import json
from flask import Flask, request, jsonify, Response
import pandas as pd
import os
import sys
import psycopg2
import traceback
from collections import OrderedDict


# Environment variables
backend_source = os.getenv('PYTHON_BACKEND_SOURCE')
csv_path = os.getenv('PYTHON_BACKEND_CSV_PATH')

# PostgreSQL connection info from env
pg_host = os.getenv('PYTHON_BACKEND_POSTGRES_HOST', 'localhost')
pg_db = os.getenv('PYTHON_BACKEND_POSTGRES_DB')
pg_user = os.getenv('PYTHON_BACKEND_POSTGRES_USER')
pg_password = os.getenv('PYTHON_BACKEND_POSTGRES_PASSWORD')

def get_csv_data(path: str):
    df = pd.read_csv(path, sep="|", encoding='utf-8')
    return df

app = Flask(__name__)

@app.route('/CSV')
def get_csv():

    CSV_records = get_csv_data(csv_path)

    start = request.args.get('start', default=0, type=int)
    end = request.args.get('end', default=None, type=int)

    sliced_df = CSV_records.iloc[start:end]

    records = sliced_df.to_dict(orient='records')

    return jsonify(records)

@app.route('/DB')
def get_db():
    start = request.args.get('start', default=0, type=int)
    end = request.args.get('end', default=None, type=int)

    # Prepare for limit and offset
    limit = None
    offset = start

    if end is not None:
        limit = end - start

    print(f"start={start}, end={end}, limit={limit}, offset={offset}")

    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(
            host=pg_host,
            database=pg_db,
            user=pg_user,
            password=pg_password
        )

        cur = conn.cursor()

        # Construct SQL query with limit and offset
        query = """
            SELECT
                "Numéro du brevet etranger / national",
                "Numéro du brevet",
                "Date de revendications de priorité",
                "Pays d'origine de revendications de priorité",
                "Code du pays d'origine de revendications de priorité",
                "Code de type de revendications de priorité"
            FROM patent
        """
        
        if limit is not None:
            query += " LIMIT %s OFFSET %s"
            cur.execute(query, (limit, offset))
        else:
            query += " OFFSET %s"
            cur.execute(query, (offset,))

        # Get column headers
        column_names = [desc[0] for desc in cur.description]
        print("Column Names:", column_names)
        print("Number of columns:", len(column_names))

        # Fetch rows
        rows = cur.fetchall()
        print(f"Number of rows returned: {len(rows)}")

        if not rows:
            return jsonify({"message": "No data found"})

        # Debug: Print first row's structure
        first_row = rows[0]
        print("First row data:", first_row)
        print("Number of values in first row:", len(first_row))

        # Verify column count matches data count
        if len(column_names) != len(first_row):
            error_msg = f"Column count mismatch: {len(column_names)} columns but {len(first_row)} values in row"
            print(error_msg)
            return jsonify({"error": error_msg}), 500


        cur.close()
        conn.close()

        return jsonify(rows)

    except Exception as e:
        print("Error:", e)
        return jsonify({"error": str(e)}), 500


app.run(host='0.0.0.0')
