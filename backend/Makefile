
VIRTUAL_ENV=env
PIP_TOOLS_VERSION=6.8.0
DOCKER_IMAGE_NAME=istio_demo_backend
DOCKER_APP_ID="$$(docker ps | awk '$$2 == "$(DOCKER_IMAGE_NAME)" { print $$1 }')"

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

local_integration_test:
	curl localhost:8000/v1/health
	@echo ''
	curl localhost:8000/v1/access/hydrogen/v1/health
	@echo ''
	curl localhost:8000/v1/access/helium/v1/health
	@echo ''

build_app: Dockerfile app.py requirements.txt
	docker build -t $(DOCKER_IMAGE_NAME) .

validate_docker_app_is_running: ADDITIONAL_MESSAGE=''
validate_docker_app_is_running: EXIT_ON_EMPTY=1
validate_docker_app_is_running: EXIT_ON_NON_EMPTY=0
validate_docker_app_is_running:
	@if [ -z "$(DOCKER_APP_ID)" ] ; then \
		if [ "$(EXIT_ON_EMPTY)" = "1" ] ; then \
			echo 'No running instances of $(DOCKER_IMAGE_NAME) were found. $(ADDITIONAL_MESSAGE)' ; \
		fi ; \
		exit $(EXIT_ON_EMPTY) ; \
	else \
		if [ "$(EXIT_ON_NON_EMPTY)" = "1" ] ; then \
			echo 'At least one running instance of $(DOCKER_IMAGE_NAME) was found. $(ADDITIONAL_MESSAGE)' ; \
		fi ; \
		exit $(EXIT_ON_NON_EMPTY) ; \
	fi

validate_docker_app_is_not_running:
	@$(MAKE) validate_docker_app_is_running EXIT_ON_EMPTY=0 EXIT_ON_NON_EMPTY=1

run_docker_app: validate_docker_app_is_not_running build_app
	docker run -e APP_NAME='hydrogen' -e KUBERNETES_NAMESPACE='default' --rm $(DOCKER_IMAGE_NAME)

docker_app_should_be_running: ADDITIONAL_MESSAGE="Please run $$(basename $(MAKE)) run_docker_app in another terminal window first."
docker_app_should_be_running:
	@$(MAKE) validate_docker_app_is_running ADDITIONAL_MESSAGE=$(ADDITIONAL_MESSAGE)

docker_app_shell: COMMAND='/bin/sh'
docker_app_shell: docker_app_should_be_running
	docker exec -it $(DOCKER_APP_ID) $(COMMAND)

docker_app_integration_tests: COMMAND="apk add curl ; echo '' ; curl localhost/v1/health ; echo '' ; curl localhost/v1/access/hydrogen/v1/health ; echo '' ; curl localhost/v1/access/helium/v1/health ; echo ''"
docker_app_integration_tests: docker_app_should_be_running
	$(MAKE) docker_app_shell COMMAND=$(COMMAND)

stop_docker_app: validate_docker_app_is_running
	docker stop $(DOCKER_APP_ID)
