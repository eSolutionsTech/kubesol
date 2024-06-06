# Cert-manager

Cert-manager creates and renews TLS certificates for workloads in your Kubernetes. See https://cert-manager.io/docs/


With `ansible-playbook 454-dummy.yaml` you can install our demos and see how we create 
Issuer (for SSL certificates), Ingress with TLS, services and pods for a full web application in Kubernetes.

In particular note we are using Issuer (not ClusterIssuer) and 
dedicated certificate for each hostname (not wildcard SSL certificate).

A list of useful commands in our setup:

```
  kubectl -n dummy get certificate

  kubectl -n dummy get issuer
  kubectl -n dummy get ingress
```

