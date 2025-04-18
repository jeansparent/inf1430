import requests
import json
import pandas as pd
import os
from io import StringIO

API_URL = os.getenv('PYTHON_FRONTEND_API_URL')

def get_api_data(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        response.encoding = 'utf-8'
        data = response.json()

        df = pd.DataFrame(data)
        df.reset_index(drop=True, inplace=True)
        if not df.empty:
            df = df.iloc[:, 1:]
        return df.to_dict(orient='records')
    except requests.exceptions.RequestException as e:
        print(f"API error: {e}")
        return []


    except requests.exceptions.RequestException as e:
        print(f"API error: {e}")
        return pd.DataFrame() 



api_url = f"{API_URL}/CSV?start=10&end=20"

# Get and display the data
# data = (get_api_data(api_url)).to_csv(index=False, sep="|" )
# data = pd.read_csv(StringIO(data), sep='|', header=1)
# print(data.to_string(index=False))

print(get_api_data(api_url))