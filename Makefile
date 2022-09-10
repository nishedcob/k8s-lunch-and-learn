
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
	$< status || ($< start && $< status)

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

## install_istio | Install Istio in the Minikube Cluster
install_istio: istioctl kubectl start_minikube
	$< install -yf k8s/istio/install-overrides.yaml

## install_istio_addons | Install recommended Istio Addons in the Minikube Cluster
install_istio_addons: kubectl install_istio
	$< apply -f istio_addons/

## install_registry | Install Docker Registry in Minikube Cluster
install_registry: kubectl start_minikube
	$< apply -f k8s/registry/registry.yaml
	@echo "Waiting for the registry to be ready..."
	@while ! ($< get deploy/registry -n registry -o json | jq '.status.readyReplicas == 1' | grep -q '^true$$') ; do \
		echo '$< get deploy/registry -n registry' ; \
		$< get deploy/registry -n registry ; \
		sleep 1 ; \
	done
	$< get deploy/registry -n registry
	@echo "The registry is ready."

## install_registry_ingress | Install Istio Ingress Configuration for Registry in the Minikube Cluster
install_registry_ingress: kubectl install_istio install_registry
	$< apply -f k8s/registry/registry-istio-ingress.yaml
