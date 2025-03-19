from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}


# execution: uvicorn api:app --host 0.0.0.0 --port 8000 --reload