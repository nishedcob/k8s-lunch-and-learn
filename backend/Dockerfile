
FROM python:3.10-alpine

ARG PORT='80'
ENV CLUSTER_DOMAIN 'cluster.local'
ENV PROTOCOL 'http'
ENV PORT ${PORT}

EXPOSE ${PORT}

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app.py app.py

CMD [ "uvicorn", "app:app", "--host", "0.0.0.0", "--port", ${PORT} ]
