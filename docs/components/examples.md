# Examples

We are providing some example manifests you could use for a quick start.

## Install

Demo apps (`450` / `452` / `454`) are **enabled by default** in `400-setup-k8s.yaml`. If you skipped them, install the full demo with `ansible-playbook 454-dummy.yaml`.

## Usage

This is a full web application, running in cluster and exposed via https. In the namespace dummy you will see the following objects:

```
$ kubectl -n dummy get ingress
NAME    CLASS    HOSTS                    ADDRESS                                     PORTS     AGE
dummy   <none>   dummy.dev2.kubesol.com   192.168.40.88,192.168.40.89,192.168.40.90   80, 443   3d16h
#                ^ access this name with https
# CLASS may show <none> when ingressClassName is omitted; Traefik still uses the
# cluster default IngressClass (nginx). See Ingress (Traefik).

$ kubectl -n dummy get certificate
NAME        READY   SECRET      AGE
dummy-tls   True    dummy-tls   3d16h
# the SSL certificate is automatically generated from ingress configuration AND Issuer:

$ kubectl -n dummy get issuer
NAME                READY   AGE
letsencrypt-dummy   True    3d16h

# the ingress is sending http requests to a service
$ kubectl -n dummy get svc
NAME    TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
dummy   ClusterIP   10.43.88.84   <none>        80/TCP    3d16h

# the service is sending requests to pods
$ kubectl -n dummy get pods
NAME      READY   STATUS    RESTARTS   AGE
dummy-0   1/1     Running   0          3d16h

# which pods are created by a statefulSet
kubectl -n dummy get sts
NAME    READY   AGE
dummy   1/1     3d16h

# PVCs use the cluster default StorageClass (no storageClassName in the StatefulSet):
$ kubectl -n dummy get pvc
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-dummy-0   Bound    pvc-ceb3e429-2084-4698-b1b0-283c82f63535   10Mi       RWO            local-path     3d16h

```

(If you previously enabled Longhorn as default, `STORAGECLASS` may show `longhorn` instead.)

You can inspect the files under `ansible/files/dummy/`. See [Storage classes](Storage-classes.md) and `./default-sc.sh` to change the default.

