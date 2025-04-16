import os
import math
import pandas as pd  # type: ignore
from nicegui import ui
from starlette.requests import Request

# === ENV VARIABLES ===
backend_source = os.getenv('PYTHON_FRONTEND_SOURCE')
csv_path = os.getenv('PYTHON_FRONTEND_CSV_PATH')
default_records = int(os.getenv('PYTHON_FRONTEND_RECORDS_PER_PAGE', '10'))

# === DATA LOADING ===
df = pd.read_csv(csv_path, sep="|")
columns = [
    {'name': col, 'label': col.rsplit('-', 1)[-1], 'field': col}
    for col in df.columns
]

# === GLOBAL STATE ===
page = 1
record_per_page = default_records
search_term = ""  # Default search term


# === TABLE RENDERING ===
@ui.refreshable
def refreshable_table():
    # Filter rows based on search term
    filtered_df = df[df.apply(lambda row: row.astype(str).str.contains(search_term, case=False).any(), axis=1)]
    
    # Pagination logic on filtered data
    start = (page - 1) * record_per_page
    end = start + record_per_page
    current_rows = [row.to_dict() for _, row in filtered_df.iloc[start:end].iterrows()]
    
    return ui.table(columns=columns, rows=current_rows, row_key=df.columns[0])


# === UTILS ===
def load_rows():
    refreshable_table.refresh()  # Refresh the table after a search or page change
    start = (page - 1) * record_per_page
    end = min(start + record_per_page, len(df))
    print(f'Loaded Page {page}: rows {start + 1} to {end}')


def load_next_rows():
    global page
    if (page * record_per_page) < len(df):
        page += 1
        load_rows()


def load_previous_rows():
    global page
    if page > 1:
        page -= 1
        load_rows()


def update_search(value: str):
    global search_term
    search_term = value
    page = 1  # Reset to page 1 after search
    load_rows()


# === MAIN UI PAGE ===
@ui.page('/')
async def main_page(request: Request):
    global record_per_page, page, search_term

    # Handle query param ?records=...
    records_str = request.query_params.get('records')
    try:
        record_per_page = int(records_str) if records_str else default_records
    except ValueError:
        record_per_page = default_records

    page = 1  # Reset to first page whenever the record count changes

    with ui.row():
        ui.input(placeholder="Search all columns...", on_change=lambda e: update_search(e.value))
        ui.button('Précédent', on_click=load_previous_rows)
        ui.button('Suivant', on_click=load_next_rows)

        with ui.dropdown_button(str(record_per_page), auto_close=True):
            for val in [10, 100, 1000, 10000]:
                ui.item(str(val), on_click=lambda v=val: ui.navigate.to(f"/?records={v}"))

    refreshable_table()
    load_rows()


# === RUN APP ===
ui.run()
