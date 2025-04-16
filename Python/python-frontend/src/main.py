# main.py
import os
import math
import pandas as pd  # type: ignore
from nicegui import app, ui

backend_source = os.getenv('PYTHON_FRONTEND_SOURCE')
csv_path = os.getenv('PYTHON_FRONTEND_CSV_PATH')
record_per_page = int(os.getenv('PYTHON_FRONTEND_RECORDS_PER_PAGE'))
page = 1
df = pd.read_csv(csv_path, sep="|")
total_pages = math.ceil(len(df) / record_per_page)
page = 1

with ui.row():
    search_input = ui.input(placeholder="Search all columns...", on_change=lambda e: update_search(e.value))
    ui.button('Précédent', on_click=lambda _: load_previous_rows())
    ui.button('Suivant', on_click=lambda _: load_next_rows())

columns = [
    {'name': col, 'label': col.rsplit('-', 1)[-1], 'field': col}
    for col in df.columns
]

@ui.refreshable
def refreshable_table():
    start = (page - 1) * record_per_page
    end = start + record_per_page
    current_rows = [row.to_dict() for _, row in df.iloc[start:end].iterrows()]
    table = ui.table(columns=columns, rows=current_rows, row_key=df.columns[0])
    return table

# Call the refreshable function once to create the initial table
table_container = refreshable_table()

def load_rows():
    refreshable_table.refresh()  # Call refresh on the decorated function
    start = (page - 1) * record_per_page
    end = start + record_per_page
    print(f'Loaded Page {page}: rows {start + 1} to {end}')

# Initial load (already done by the first call to refreshable_table)

# Function to go to the next page
def load_next_rows():
    global page
    if (page * record_per_page) < len(df):  # prevent going beyond last page
        page += 1
        load_rows()

# Function to go to the previous page
def load_previous_rows():
    global page
    if page > 1:  # prevent going below page 1
        page -= 1
        load_rows()

ui.run()