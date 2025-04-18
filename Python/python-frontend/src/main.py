import os
import pandas as pd
from nicegui import ui
from starlette.requests import Request
import requests
from io import StringIO
from urllib.parse import urlencode

frontend_source = os.getenv('PYTHON_FRONTEND_SOURCE')
csv_path = os.getenv('PYTHON_FRONTEND_CSV_PATH')
default_records = int(os.getenv('PYTHON_FRONTEND_RECORDS_PER_PAGE', '10'))
API_URL = os.getenv('PYTHON_FRONTEND_API_URL')



def get_csv_data(page, record_per_page):
    try:
        df = pd.read_csv(csv_path, sep="|")
        df.reset_index(drop=True, inplace=True)
        start = (page - 1) * record_per_page
        end = page * record_per_page
        sliced = df.iloc[start:end]
        return sliced.to_dict(orient='records')
    except Exception as e:
        print(f"CSV error: {e}")
        return []

def get_api_data(page, record_per_page):
    try:
        response = requests.get(f"{API_URL}/CSV?start={(page - 1) * record_per_page}&end={page * record_per_page}")
        response.raise_for_status()
        response.encoding = 'utf-8'
        data = response.json()

        df = pd.DataFrame(data)

        df.reset_index(drop=True, inplace=True)

        column_order_by_index = [1, 0, 5, 4, 3, 2]

        df = df.iloc[:, column_order_by_index]

        return df.to_dict(orient='records')

    except requests.exceptions.RequestException as e:
        print(f"API error: {e}")
        return []


def make_columns(rows):
    sample = rows[0] if rows else {}
    return [{'name': col, 'label': str(col).rsplit('-', 1)[-1], 'field': col} for col in sample.keys()]


def create_page(data_loader):
    async def page_fn(request: Request):
        try:
            record_per_page = int(request.query_params.get('records') or default_records)
        except ValueError:
            record_per_page = default_records

        page = int(request.query_params.get('page', 1))

        all_data = data_loader(page, record_per_page)
        total = len(all_data)

        def refresh_table():
            nonlocal all_data, total
            all_data = data_loader(page, record_per_page)
            total = len(all_data)
            table.rows = all_data
            table.update()

        def load_next():
            nonlocal page
            
            if isinstance(all_data, pd.DataFrame):
                max_page = (total + record_per_page - 1) // record_per_page
                if page < max_page:
                    page += 1
                    query = urlencode({'records': record_per_page, 'page': page})
                    ui.navigate.to(f"{request.url.path}?{query}")
            else:
                if len(all_data) == record_per_page:
                    page += 1
                    query = urlencode({'records': record_per_page, 'page': page})
                    ui.navigate.to(f"{request.url.path}?{query}")

        def load_prev():
            nonlocal page
            if page > 1:
                page -= 1
                query = urlencode({'records': record_per_page, 'page': page})
                ui.navigate.to(f"{request.url.path}?{query}")


        columns = make_columns(all_data)
        row_key = list(all_data[0].keys())[0] if all_data else "id"

        with ui.column().classes('w-full p-4'):
            with ui.row().classes('items-center justify-between w-full gap-4'):
                ui.input(
                    placeholder="Search all columns...",
                    on_change=lambda e: print(f"Search: {e.value}")
                ).classes('w-1/3')

                ui.button('Précédent', on_click=load_prev).classes('w-1/6')
                ui.button('Suivant', on_click=load_next).classes('w-1/6')

                with ui.dropdown_button(str(record_per_page), auto_close=True).classes('w-1/6'):
                    for val in [10, 100, 1000, 10000]:
                        ui.item(
                            str(val),
                            on_click=lambda v=val: ui.navigate.to(f"{request.url.path}?records={v}&page={page}")
                        )

            table = ui.table(columns=columns, rows=all_data, row_key=row_key).classes('w-full')

    return page_fn


ui.page('/CSV')(create_page(get_csv_data))
ui.page('/API')(create_page(get_api_data))

ui.run()
