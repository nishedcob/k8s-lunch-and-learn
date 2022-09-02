
FROM python:3.10-alpine

ARG PORT='80'
ENV APP_NAME ''
ENV KUBERNETES_NAMESPACE ''
ENV CLUSTER_DOMAIN 'cluster.local'
ENV PROTOCOL 'http'
ENV INTERNAL_PROTOCOL ''
ENV EXTERNAL_PROTOCOL ''
ENV PORT ${PORT}
ENV ALL_REQUESTS_K8S_DNS ''

EXPOSE ${PORT}

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app.py app.py

CMD [ "uvicorn", "app:app", "--host", "0.0.0.0", "--port", ${PORT} ]
