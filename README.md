![License](https://img.shields.io/github/license/bgulla/osdk-burrito-demo)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/bgulla/osdk-burrito-demo)
![Helm Chart Version](https://img.shields.io/badge/dynamic/yaml?label=helm%20chart&query=version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbgulla%2Fosdk-burrito-demo%2Fmain%2Fchart%2FChart.yaml)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/osdk-burrito-demo)](https://artifacthub.io/packages/search?repo=osdk-burrito-demo)
![Helm Repository](https://img.shields.io/badge/helm%20repo-bgulla/osdk--burrito--demo-blue)

# OSDK Burrito Demo
TLDR

## Installing via Helm-CLI (not Apollo)
```bash
helm repo add bgulla https://bgulla.github.io/osdk-burrito-demo
helm repo update
helm install burrito-demo bgulla/osdk-burrito-demo --namespace default
```

## Helm `values.yaml`
<!-- helm-docs -->

#### secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: osdk-burrito-demo-secret
type: Opaque
data:
  FOUNDRY_HOST: <base64-encoded-host>
  FOUNDRY_TOKEN: <base64-encoded-token>
```
