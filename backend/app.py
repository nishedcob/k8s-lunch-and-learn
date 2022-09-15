
import os
from fastapi import FastAPI, Response
from typing import Optional
import requests
from requests.exceptions import ConnectionError

app = FastAPI()

def get_required_environment_variable(name: str, default: Optional[str] = None) -> str:
    value = os.getenv(name, default)
    if default is not None and value == '':
        value = default
    assert value is not None and value != '', f'{name} environment variable must be defined.'
    return value

APP_NAME = get_required_environment_variable('APP_NAME')
KUBERNETES_NAMESPACE = get_required_environment_variable('KUBERNETES_NAMESPACE')
CLUSTER_DOMAIN = get_required_environment_variable('CLUSTER_DOMAIN', 'cluster.local')
PROTOCOL = get_required_environment_variable('PROTOCOL', 'http')
INTERNAL_PROTOCOL = get_required_environment_variable('INTERNAL_PROTOCOL', PROTOCOL)
EXTERNAL_PROTOCOL = get_required_environment_variable('EXTERNAL_PROTOCOL', PROTOCOL)
PORT = get_required_environment_variable('PORT', '8000')
ALL_REQUESTS_K8S_DNS = get_required_environment_variable('ALL_REQUESTS_K8S_DNS', 'FALSE') == 'TRUE'

@app.get('/v1/health')
def health_check():
    return {
        'app': APP_NAME,
        'call': 'GET /v1/health'
    }

@app.get('/v1/access/{service}/{api_version}/{endpoint}')
def access(service: str, api_version: str, endpoint: str, response: Response):
    if service == APP_NAME and not ALL_REQUESTS_K8S_DNS:
        host = f'{INTERNAL_PROTOCOL}://localhost:{PORT}'
    else:
        host = f'{EXTERNAL_PROTOCOL}://{service}.{KUBERNETES_NAMESPACE}.svc.{CLUSTER_DOMAIN}'
    try:
        req = requests.get(f'{host}/{api_version}/{endpoint}')
        upstream = {
            'status_code': req.status_code,
            'body': req.json()
        }
    except ConnectionError:
        upstream = {
            'status_code': 404,
            'body': {
                'error_msg': f'Failed to connect to upstream host: {host}'
            }
        }
    response.status_code = upstream.get('status_code', 500)
    return {
        'app': APP_NAME,
        'hostname': host,
        'call': f'GET /access/{service}/{api_version}/{endpoint}',
        'params': {
            'service': service,
            'api_version': api_version,
            'endpoint': endpoint
        },
        'response': upstream
    }
