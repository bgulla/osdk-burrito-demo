# OSDK Burrito Demo

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
