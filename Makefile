# Variables
IMAGE_NAME = harbor.hokies.dev/bgulla/burrito-hunter:demo
CONTAINER_NAME = burrito-hunter
ENV_FILE = burrito.env
CHART_NAME = osdk-burrito-demo
NAMESPACE = default

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) --build-arg FOUNDRY_TOKEN=${FOUNDRY_TOKEN} --build-arg FOUNDRY_HOST=${FOUNDRY_HOST} src -f ./Dockerfile

# Run the Docker container
run:
	docker run --rm -p 5000:5000 --name $(CONTAINER_NAME) \
	$(IMAGE_NAME)

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

# Push the Docker image to the registry
push:
	docker push $(IMAGE_NAME)

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
