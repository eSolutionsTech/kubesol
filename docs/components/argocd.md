# ArgoCD

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes (the "CD" part in CI/CD). 
Read more at:

- https://argo-cd.readthedocs.io/en/stable/
- https://github.com/argoproj/argo-cd

## Web interface
To access the web interface:

```
# retrieve the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo

# get the access URL
kubectl -n argocd get ingress
```

Alternatively, the web interface can be accessed with port forwarding:

```
kubectl port-forward service/argocd-server -n argocd 8080:443
# open the browser on http://localhost:8080 and accept the certificate
```

![](argocd.png "")

## Usage

ArgoCD is installed but unconfigured. You can configure it with the web interface or with the declarative method described in the official documentation https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/ .


