#! /bin/sh

/usr/local/bin/uvicorn app:app --host 0.0.0.0 --port $PORT
