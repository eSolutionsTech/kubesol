# Kubernetes dashboard

Kubernetes dashboard is a web-based Kubernetes interface. 

It is part of the official Kubernetes project: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/ . 

## Install

To check it: 

```
$ kubectl -n kubernetes-dashboard get pods
NAME                                                    READY   STATUS    RESTARTS   AGE
kubernetes-dashboard-api-848d6d4b8f-zvc9n               1/1     Running   0          15m
kubernetes-dashboard-auth-7b7cbc9d46-hw7zh              1/1     Running   0          15m
kubernetes-dashboard-kong-76dff7b666-mjlqn              1/1     Running   0          16h
kubernetes-dashboard-metrics-scraper-555758b9bf-mlqtw   1/1     Running   0          16h
kubernetes-dashboard-web-846f5f49b-z7rk5                1/1     Running   0          16h
```

To install it: `ansible playbook 420-kubernetes-dashboard.yaml 422-kubernetes-dashboard-ingress.yaml`

## To access web interface

Get the token with this command:

```
  kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={.data.token} | base64 -d ; echo
```

If you deployed the ingress, use `https://kubernetes-dashboard.<<ext_dns_name>>`. You can get the exact address with:
```
 kubectl -n kubernetes-dashboard get ingress
```

![](screenshot4.png "")

![](kubernetes-dashboard.png "")

Otherwise:

```
  kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
  # open browser, accept SSL warning at https://localhost:8443
```

