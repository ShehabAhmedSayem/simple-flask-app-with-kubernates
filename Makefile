include .env
export

# Variables
IMAGE_NAME=sayem/flask-app
KUBE_NAMESPACE=default
DOCKER_USERNAME ?= $(DOCKER_USERNAME)
DOCKER_TOKEN ?= $(DOCKER_TOKEN)

# Targets
all: build push deploy

build:
	docker build -t $(IMAGE_NAME) ./src/

docker-login:
	@echo "Logging in to docker hub..."
	@if [ -z $(DOCKER_USERNAME) ] || [ -z $(DOCKER_TOKEN) ]; then\
		echo "Error: DOCKER_USERNAME or DOCKER_TOKEN is not set"; \
		exit 1; \
	fi
	@echo "$(DOCKER_TOKEN)" | docker login -u $(DOCKER_USERNAME) --password-stdin

push: docker-login
	docker push $(IMAGE_NAME)

deploy:
	kubectl apply -f deployment.yaml --namespace $(KUBE_NAMESPACE)

clean:
	kubectl delete -f deployment.yaml --namespace $(KUBE_NAMESPACE)

.PHONY: all build push deploy clean