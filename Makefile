# Variables
IMAGE_NAME = baryte-container-registry.palantirfoundry.com/burrito-hunter
TAG=0.0.2
CONTAINER_NAME = burrito-hunter
ENV_FILE = burrito.env
CHART_NAME = osdk-burrito-demo
NAMESPACE = default
PLATFORM ?= "linux/amd64,linux/arm64"
BUILDER_NAME ?= mybuilder

include burrito.env

# Build the Docker image
build:
	# if this is not working, run make buildx-init
	docker buildx build --load --platform $(PLATFORM) -t $(IMAGE_NAME):${TAG} --build-arg FOUNDRY_TOKEN=${FOUNDRY_TOKEN} --build-arg FOUNDRY_URL=$(FOUNDRY_URL) src -f ./Dockerfile

# creates a builder instance to enable multi-arch builds via qemu
buildx-init:
	docker buildx create --name ${BUILDER_NAME} --use --driver docker-container --bootstrap

push:
# Push the Docker image to the registry
	docker push ${IMAGE_NAME}:${TAG}
# Run the Docker container
run:
	docker run --rm -p 5000:5000 --name $(CONTAINER_NAME) \
	--env-file=./burrito.env \
	$(IMAGE_NAME):${TAG}

## Run the docker container locally with ./src mounted for live edits
run-debug:
	docker run --rm -p 5000:5000 --name $(CONTAINER_NAME) \
	-v ${PWD}/src:/app \
	--env-file=./burrito.env \
	$(IMAGE_NAME):${TAG}

# Stop the Docker container
stop:
	docker stop $(CONTAINER_NAME)

# View logs from the running container
logs:
	docker logs -f $(CONTAINER_NAME)

# Clean up stopped containers and dangling images
clean:
	docker system prune -f

# Rebuild and run the container
rerun: stop build run

# Test the application (you can customize this to your testing needs)
test:
	curl http://localhost:5000/docs

# Build the Helm chart package
helm-build:
	helm package ./chart -d ./chart

# Install the Helm chart
helm-install:
	helm install $(CHART_NAME) ./chart --namespace $(NAMESPACE)

# Upgrade the Helm chart
helm-upgrade:
	helm upgrade $(CHART_NAME) ./chart --namespace $(NAMESPACE)

# Uninstall the Helm chart
helm-uninstall:
	helm uninstall $(CHART_NAME) --namespace $(NAMESPACE)

# Lint the Helm chart
helm-lint:
	helm lint ./chart

# Template the Helm chart
helm-template:
	helm template $(CHART_NAME) ./chart --namespace $(NAMESPACE)

.PHONY: build run stop logs clean rerun test push helm-build helm-install helm-upgrade helm-uninstall helm-lint helm-template
