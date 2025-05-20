![License](https://img.shields.io/github/license/bgulla/osdk-burrito-demo)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/bgulla/osdk-burrito-demo)
![Helm Chart Version](https://img.shields.io/badge/dynamic/yaml?label=helm%20chart&query=version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbgulla%2Fosdk-burrito-demo%2Fmain%2Fchart%2FChart.yaml)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/osdk-burrito-demo)](https://artifacthub.io/packages/search?repo=osdk-burrito-demo)
![Helm Repository](https://img.shields.io/badge/helm%20repo-bgulla/osdk--burrito--demo-blue)
# OSDK Burrito Demo


![HelmCharts](/src/static/screenshot.png?raw=true) 

## Testing Locally
### Required Initialization
Since we do not want to store secrets inside of a Git repository, you need to perform a few actions before building the image locally.


Move the example `burrito.env.example` file to `burrito.env` and fill in the missing variables
```bash
mv ./burrito.env.example ./burrito.env
vim ./burrito.env # fill in the missing values
```

## Building the container
```bash
make build
```

## Running the container (Local)
Note: we are utilizing an `--env-file` to inject our `FOUNDRY_TOKEN` and `FOUNDRY_URL` into the containers environment. When we do this in Kubernetes, this will be provided to use via [ secrets-injection](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/) from the `osdk-burrito-demo-secret` secret. 

### `docker run`
```bash
# `make run` will also do the following
	docker run --rm -p 5000:5000 --name burrito-hunter \
	  --env-file=./burrito.env \
	  baryte-container-registry.palantirfoundry.com/burrito-hunter:0.0.2
```
### `docker run` (debug)
In circumstances where you want to live debug/edit the Python Flask code, you are able to run with the files mounted as an external volume. As you edit files in `./src`, the Flask runtime will automatically detect them and reload the Flask server allowing you to view your edits in real-time without restarting the container instance.
```bash
# `make run-debug` will also do the following
	docker run --rm -p 5000:5000 --name burrito-hunter \
	  --env-file=./burrito.env \
	  baryte-container-registry.palantirfoundry.com/burrito-hunter:0.0.2
```

### Running the container (Kubernetes/Apollo Environment)
## Prerequesites 
In order to run our container on Kubernetes, we will need to provide it with secrets for connecting to our Foundry/Ontology instance. 

#### Via Apollo
[Documentation](https://www.palantir.com/docs/apollo/managing-secrets/add-edit-delete-secrets)
```txt
secret_name: osdk-burrito-demo-secret
  FOUNDRY_HOST: <value>
  FOUNDRY_TOKEN: <value>
```

#### manually via `secret.yaml`
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: osdk-burrito-demo-secret
type: Opaque
data:
  FOUNDRY_HOST: <base64-encoded-host>
  FOUNDRY_TOKEN: <base64-encoded-token>
  FOUNDRY_URL: <base64-encoded-token>
```

## Installing via Helm-CLI (Debug only)
If you are deploying your container locally without Apollo, you can use the `helm-cli` below.
```bash
helm repo add bgulla https://bgulla.github.io/osdk-burrito-demo
helm repo update
helm install burrito-demo bgulla/osdk-burrito-demo --namespace default
```





