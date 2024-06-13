# Cert-manager

Cert-manager creates and renews TLS certificates for workloads in your Kubernetes. See https://cert-manager.io/docs/

## Install

It is required (in our setup) by all Ingresses (that't it all web interfaces).

To check it: 

```
$ kubectl -n cert-manager get pods
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-cainjector-698464d9bb-79xvg   1/1     Running   0          16h
cert-manager-d7db49bf4-d5qbg               1/1     Running   0          16h
cert-manager-webhook-f6c9958d-zr57m        1/1     Running   0          16h
```

To install it: `ansible-playbook 430-cert-manager.yaml`

## Usage

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

