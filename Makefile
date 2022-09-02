
minikube:
	@if [ -z "$$(which minikube)" ] ; then \
		if [ ! -z "$$(which brew)" ] ; then \
			brew install minikube ; \
		elif [ "$$(uname)" = "Darwin" ]; then \
			echo "Please install brew before proceeding." ; \
			exit 1 ; \
		elif [ "$$(uname)" = "Linux" ] ; then \
			echo "TODO: Non-brew fallback for Linux" ; \
			exit 1 ; \
		else \
			echo "Your automatic install on your OS is not supported yet. Please install minikube manually before proceeding." ; \
			exit 1 ; \
		fi ; \
	else \
		echo "minikube has already been installed and found in your PATH." ; \
	fi
