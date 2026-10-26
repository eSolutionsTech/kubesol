# Ingress controller (Traefik)

RKE2 deploys **Traefik** as the in-cluster Ingress controller (`ingress-controller: traefik` in the RKE2 config written by our Ansible playbooks).

To keep existing manifests working, Traefik is configured with the **Kubernetes Ingress NGINX** provider so it still accepts:

- `ingressClassName: nginx` (and the legacy `kubernetes.io/ingress.class: nginx` annotation)
- common `nginx.ingress.kubernetes.io/*` annotations used by Kubesol components

You do **not** need to change Ingress resources in the playbooks for the switch from ingress-nginx.

Annotation support is broad but not 100% identical to ingress-nginx. See Traefik’s [NGINX annotations reference](https://doc.traefik.io/traefik/master/reference/routing-configuration/kubernetes/ingress-nginx/).

The gateway VM still runs a separate nginx reverse proxy (`280-gw.yaml`); that is unrelated to this in-cluster controller.

## Install

Traefik is installed by RKE2 when the cluster is created. Configuration is applied via HelmChartConfig at `/var/lib/rancher/rke2/server/manifests/rke2-traefik-config.yaml` (see `310-controller-one.yaml` / `330-more-controllers.yaml`).

Kubesol also creates an IngressClass named **`nginx`** (controller `k8s.io/ingress-nginx`) and marks it as the **default**. Traefik’s own `traefik` class stays available but is not the default. You may still see `rke2-ingress-nginx-migration` from RKE2; ignore it for day-to-day use — our Ingresses target `nginx`.

On an existing cluster, re-run `ansible-playbook 405-get-nodes.yaml` (or `400-setup-k8s.yaml`) to apply the IngressClass.

Check it with:

```
$ kubectl -n kube-system get pods | grep -E 'traefik|ingress'
helm-install-rke2-traefik-...          0/1     Completed   ...
svclb-traefik-...                      2/2     Running     ...
rke2-traefik-...                       1/1     Running     ...

$ kubectl get ingressclass
NAME      CONTROLLER                     AGE
nginx (default)   k8s.io/ingress-nginx            ...
traefik           traefik.io/ingress-controller   ...
```

(Exact pod names vary by RKE2 / Traefik chart version.)

## Usage

With `ansible-playbook 454-dummy.yaml` you can install our demos and see how we create
Issuer (for SSL certificates), Ingress with TLS, services and pods for a full web application in Kubernetes.

Useful commands:

```
  kubectl get ingressclasses
  kubectl -n kube-system get pods | grep traefik

  kubectl -n dummy get ingress
  kubectl -n dummy get issuer
```
