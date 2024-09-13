# Cert-manager

Cert-manager creates and renews TLS certificates for workloads in your Kubernetes. See https://cert-manager.io/docs/

## Install

It is required (in our setup) by all Ingresses (that't it all web interfaces). 

Please note if you do not have 
the DNS setup for the names defined in `ext_dns_name` variable as described in 
[Quickstart guide](../cluster/Quickstart.md), 
the certificate(s) will remain in the state `Ready: False`, 
a generic default SSL certificate will be used
and in browser you will see the well known SSL Certificate Warning.

To check it: 

```
$ kubectl -n cert-manager get pods
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-cainjector-698464d9bb-79xvg   1/1     Running   0          16h
cert-manager-d7db49bf4-d5qbg               1/1     Running   0          16h
cert-manager-webhook-f6c9958d-zr57m        1/1     Running   0          16h
```

To install it: `ansible-playbook 410-cert-manager.yaml`

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

## Troubleshooting

The official docs in very good on troubleshooting:

- https://cert-manager.io/docs/troubleshooting/
- https://cert-manager.io/docs/troubleshooting/acme/

Basically check the CRDs in order with `get / describe` on each object: certificate, certificateRequest, issuer / clusterIssuer, order, challenges. Then also look at the `ingress` and try http requests from outside and DNS resolution from both inside and outside the kubernetes cluster. 


