
import os
from fastapi import FastAPI, Response
from typing import Optional
import requests

app = FastAPI()

def get_required_environment_variable(name: str, default: Optional[str] = None) -> str:
    value = os.getenv(name, default)
    assert value is not None, f'{name} environment variable must be defined.'
    return value

APP_NAME = get_required_environment_variable('APP_NAME')
KUBERNETES_NAMESPACE = get_required_environment_variable('KUBERNETES_NAMESPACE')
CLUSTER_DOMAIN = get_required_environment_variable('CLUSTER_DOMAIN', 'cluster.local')
PROTOCOL = get_required_environment_variable('PROTOCOL', 'http')
INTERNAL_PROTOCOL = get_required_environment_variable('INTERNAL_PROTOCOL', PROTOCOL)
EXTERNAL_PROTOCOL = get_required_environment_variable('EXTERNAL_PROTOCOL', PROTOCOL)

@app.get('/v1/health')
def health_check():
    return {
        'app': APP_NAME,
        'call': 'GET /v1/health'
    }

@app.get('/access/{service}/{api_version}/{endpoint}')
def access(service: str, api_version: str, endpoint: str, response: Response):
    if service == APP_NAME:
        host = f'{INTERNAL_PROTOCOL}://localhost:8000'
    else:
        host = f'{EXTERNAL_PROTOCOL}://{service}.{KUBERNETES_NAMESPACE}.svc.{CLUSTER_DOMAIN}'
    req = requests.get(f'{host}/{api_version}/{endpoint}')
    response.status_code = req.status_code
    return {
        'app': APP_NAME,
        'hostname': host,
        'call': f'GET /access/{service}/{api_version}/{endpoint}',
        'params': {
            'service': service,
            'api_version': api_version,
            'endpoint': endpoint
        },
        'response': {
            'status_code': req.status_code,
            'body': req.json()
        }
    }
