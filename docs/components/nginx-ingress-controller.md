# Nginx ingress controller

Ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.
This is installed by default in our project. Docs at 
https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md 

## Install

It is installed by default. Check it with:

```
$ kubectl -n kube-system get pods | grep ingress
helm-install-rke2-ingress-nginx-tx6gh                  0/1     Completed   0          17h
rke2-ingress-nginx-controller-f9dkx                    1/1     Running     0          16h
rke2-ingress-nginx-controller-nl9hv                    1/1     Running     0          16h
rke2-ingress-nginx-controller-zgbc7                    1/1     Running     0          16h
```

## Usage

With `ansible-playbook 454-dummy.yaml` you can install our demos you see how we create 
Issuer (for SSL certificates), Ingress with TLS, services and pods for a full web application in Kubernetes.

A list of useful commands in our setup:

```
  kubectl get ingressclasses
  kubectl -n kube-system get pods | grep nginx

  kubectl -n dummy get ingress
  kubectl -n dummy get issuer
```

