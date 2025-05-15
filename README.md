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
