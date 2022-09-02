
VIRTUAL_ENV=env
PIP_TOOLS_VERSION=6.8.0
DOCKER_IMAGE_NAME=istio_demo_backend

$(VIRTUAL_ENV):
	python3 -m venv $@

$(VIRTUAL_ENV)/lib/python3.8/site-packages/piptools: $(VIRTUAL_ENV)
	$(VIRTUAL_ENV)/bin/pip install pip-tools==$(PIP_TOOLS_VERSION)

$(VIRTUAL_ENV)/bin/pip-sync: $(VIRTUAL_ENV)/lib/python3.8/site-packages/piptools

$(VIRTUAL_ENV)/bin/pip-compile: $(VIRTUAL_ENV)/lib/python3.8/site-packages/piptools

requirements.txt: $(VIRTUAL_ENV)/bin/pip-compile requirements.in
	$^

install_dependencies: $(VIRTUAL_ENV)/bin/pip-sync requirements.txt
	$^

run_app: install_dependencies
	APP_NAME='hydrogen' KUBERNETES_NAMESPACE='default' env/bin/uvicorn app:app --reload

build_app: Dockerfile app.py requirements.txt
	docker build -t $(DOCKER_IMAGE_NAME) .

run_docker_app: build_app
	docker run -e APP_NAME='hydrogen' -e KUBERNETES_NAMESPACE='default' --rm $(DOCKER_IMAGE_NAME)
