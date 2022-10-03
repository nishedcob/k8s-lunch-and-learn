
REGISTRY_NAMESPACE=kube-system
DOCKER_REGISTRY_HOST=registry
DOCKER_IMAGE_NAME=istio_demo_backend
DOCKER_REGISTRY_NAME=backend:latest

default: help

include dependencies.mk

## help | show this help command
help: SHELL=/bin/bash
help: Makefile dependencies.mk
	@sed -n 's/^## //p' <(cat $^) | column -ts '|'

## minikube | ensure minikube is installed in PATH
minikube:
	@if [ -z "$$(which $@)" ] ; then \
		if [ ! -z "$$(which brew)" ] ; then \
			if [ "$$(uname)" = "Darwin" ] && [ -z "$$(which docker)" ] ; then \
				brew install --casks docker ; \
			fi ; \
			brew install $@ ; \
		elif [ "$$(uname)" = "Darwin" ]; then \
			echo "Please install brew before proceeding." ; \
			exit 1 ; \
		elif [ "$$(uname)" = "Linux" ] ; then \
			if [ -z "$$(which curl)" ] || [ -z "$$(which sudo)" ] || [ -z "$$(which install)" ] ; then \
				if [ -z "$$(which curl)" ] ; then \
					echo "Please install curl before proceeding." ; \
				fi ; \
				if [ -z "$$(which sudo)" ] ; then \
					echo "Please install sudo before proceeding." ; \
				fi ; \
				if [ -z "$$(which install)" ] ; then \
					echo "Please install `install` before proceeding." ; \
				fi ; \
				exit 1 ; \
			fi ; \
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 ; \
			sudo install minikube-linux-amd64 /usr/local/bin/minikube ; \
		else \
			echo "Your automatic install on your OS is not supported yet. Please install $@ manually before proceeding." ; \
			exit 1 ; \
		fi ; \
	else \
		echo "$@ has already been installed and found in your PATH." ; \
	fi

## kubectl | ensure kubectl is installed in PATH
kubectl:
	@if [ -z "$$(which $@)" ] ; then \
		if [ ! -z "$$(which brew)" ] ; then \
			brew install $@ ; \
		elif [ "$$(uname)" = "Darwin" ]; then \
			echo "Please install brew before proceeding." ; \
			exit 1 ; \
		elif [ "$$(uname)" = "Linux" ] ; then \
			if [ -z "$$(which snap)" ] ; then \
				echo 'Please install snap before proceeding.' ; \
				exit 1 ; \
			fi ; \
			snap install $@ --classic ; \
		else \
			echo "Your automatic install on your OS is not supported yet. Please install $@ manually before proceeding." ; \
			exit 1 ; \
		fi ; \
	else \
		echo "$@ has already been installed and found in your PATH." ; \
	fi

## start_minikube | create or start a local minikube cluster if one is not already running
start_minikube: minikube kubectl
	@if ! $< status ; then \
		$< start ; \
		$< status ; \
		if [ "$$(uname -s)" = 'Darwin' ] ; then \
			$(MAKE) gsed ; \
		fi ; \
		minikube addons list \
			| $(if $(filter $(shell uname -s),Darwin),g,)sed 's/\s//g' \
			| awk -F'|' '$$2 == "registry" { print $$4 }' \
			| grep -q '^disabled$$' && minikube addons enable registry ; \
	fi

## status_minikube | check the status of the local minikube cluster if one exists
status_minikube: minikube
	$< status

## stop_minikube | stop running the local minikube cluster without losing the state of what workloads it should run
stop_minikube: minikube
	$< stop

## delete_minikube | stop and destroy the local minikube cluster and lose its state as to what workloads to run
delete_minikube: minikube
	$< delete

## destroy_minikube | alias for delete_minikube
destroy_minikube: delete_minikube

## istioctl | ensure istioctl is installed in PATH
istioctl:
	@if [ -z "$$(which $@)" ] ; then \
		if [ ! -z "$$(which brew)" ] ; then \
			brew install $@ ; \
		elif [ "$$(uname)" = "Darwin" ]; then \
			echo "Please install brew before proceeding." ; \
			exit 1 ; \
		elif [ "$$(uname)" = "Linux" ] ; then \
			if [ -z "$$(which curl)" ] || [ -z "$$(which sudo)" ] || [ -z "$$(which install)" ] ; then \
				if [ -z "$$(which curl)" ] ; then \
					echo "Please install curl before proceeding." ; \
				fi ; \
				if [ -z "$$(which sudo)" ] ; then \
					echo "Please install sudo before proceeding." ; \
				fi ; \
				if [ -z "$$(which install)" ] ; then \
					echo "Please install `install` before proceeding." ; \
				fi ; \
				exit 1 ; \
			fi ; \
			curl -L https://istio.io/downloadIstio | sh - ; \
			cd istio-* ; \
			sudo install bin/istioctl /usr/local/bin/istioctl ; \
		else \
			echo "Your automatic install on your OS is not supported yet. Please install $@ manually before proceeding." ; \
			exit 1 ; \
		fi ; \
	else \
		echo "$@ has already been installed and found in your PATH." ; \
	fi

## k8s/istio/install-overrides.yaml | Build k8s/istio/install-overrides.yaml for the current machine architecture
k8s/istio/install-overrides.yaml:
	cd k8s/istio ; $(MAKE) $$(basename $@)

## install_istio | Install Istio in the Minikube Cluster
install_istio: istioctl kubectl start_minikube k8s/istio/install-overrides.yaml
	$< install -yf k8s/istio/install-overrides.yaml

## install_istio_addons | Install recommended Istio Addons in the Minikube Cluster
install_istio_addons: kubectl install_istio
	$< apply -f istio_addons/

## minikube_tunnel | Forward localhost ports to minikube ingress ports, requires sudo and its own terminal
minikube_tunnel: minikube start_minikube
	$< tunnel

## build_backend_image | Build the docker image required for the demo backend
build_backend_image:
	cd backend; $(MAKE) build_app

## create_docker_tag | Tag the docker image for the demo backend to push it to the local minikube registry
create_docker_tag: build_backend_image
	docker tag $(DOCKER_IMAGE_NAME):latest $(DOCKER_REGISTRY_HOST):5000/$(DOCKER_REGISTRY_NAME)

## root_configuration | Local DNS configuration (/etc/hosts) to push the containers to the local minikube registry
root_configuration: create_docker_tag
	sudo touch /etc/hosts
	grep -q '$(DOCKER_REGISTRY_HOST)' /etc/hosts || echo '127.0.0.1 $(DOCKER_REGISTRY_HOST)' | sudo tee -a /etc/hosts
	@if [ "$$(uname -s)" = 'Darwin' ] ; then \
		$(MAKE) gsed ; \
	fi
	sudo $(if $(filter $(shell uname -s),Darwin),g,)sed 's/.*$(DOCKER_REGISTRY_HOST).*/127.0.0.1 $(DOCKER_REGISTRY_HOST)/' -i /etc/hosts

## docker_push_backend | Docker Push Demo Backend Container Image to minikube registry
docker_push_backend: start_minikube root_configuration
	@if ( [ "$$(uname -s)" = 'Darwin' ] && lsof -i :5000 ) \
			|| ( [ "$$(uname -s)" = 'Linux' ] && sudo netstat -tupln | grep -q ':5000 ' ) \
			; then \
		echo 'Please stop any applications that are listening to port 5000' ; \
		exit 1 ; \
	fi
	kubectl port-forward -n $(REGISTRY_NAMESPACE) svc/registry 5000:80 &
	@sleep 5
	@if [ "$$(uname -s)" = "Darwin" ] ; then \
		mkdir -pv ~/.docker ; \
		if [ ! -f ~/.docker/daemon.json ] ; then \
			echo "{}" > ~/.docker/daemon.json ; \
		fi ; \
		jq '."insecure-registries"=["$(DOCKER_REGISTRY_HOST):5000"]' ~/.docker/daemon.json > ~/.docker/daemon.json.tmp ; \
		mv -v ~/.docker/daemon.json.tmp ~/.docker/daemon.json ; \
	fi
	docker push $(DOCKER_REGISTRY_HOST):5000/$(DOCKER_REGISTRY_NAME)
	kill $$(pgrep kubectl)

## istio_injection_label | Enable Istio auto injection on the default namespace
istio_injection_label: install_istio_addons
	@if !(kubectl get ns default -o json | jq '.metadata.labels."istio-injection"=="enabled"' | grep -q '^true$$') ; then \
		kubectl label namespace default istio-injection=enabled ; \
	fi

## create_daemon_file | Create Docker Daemon File on Linux hosts
create_daemon_file: REGISTRY_IP=$$(kubectl get svc/registry -n $(REGISTRY_NAMESPACE) -o json | jq -r '.spec.clusterIP')
create_daemon_file: minikube
	$< ssh "sudo printf '{\n\t\"insecure-registries\":[\n\t\t\"$(REGISTRY_IP)\"\n\t]\n}\n\n' | sudo tee -a /etc/docker/daemon.json"
	$< ssh "sudo cat /etc/docker/daemon.json"
	$< ssh "sudo systemctl restart docker"

## backend_apply | Deploy a single backend service to minikube
backend_apply: BACKEND_SERVICE=''
backend_apply: istio_injection_label docker_push_backend
	if [ '$(BACKEND_SERVICE)' != '' ] ; then \
		kubectl apply -k k8s/backend/$(BACKEND_SERVICE) ; \
		kubectl apply -k k8s/security/backend/$(BACKEND_SERVICE) ; \
	else \
		echo "BACKEND_SERVICE arg is empty please specify the backend service" ; \
		exit 1 ; \
	fi

## apply_all_backends | Deploy all backends to minikube
apply_all_backends: istio_injection_label docker_push_backend
	for BACKEND in 'hydrogen' 'helium' 'oxygen' 'sodium' 'chlorine' ; do \
		$(MAKE) backend_apply BACKEND_SERVICE=$$BACKEND ; \
	done
