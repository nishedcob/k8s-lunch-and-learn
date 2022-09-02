
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

start_minikube: minikube kubectl
	$< status || ($< start && $< status)

status_minikube: minikube
	$< status

stop_minikube: minikube
	$< stop

delete_minikube: minikube
	$< delete

destroy_minikube: delete_minikube
