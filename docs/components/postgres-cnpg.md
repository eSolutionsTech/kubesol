# Postgresql CNPG

CNPG (Cloud Native Postgres operator) is an opetaror for deploying PostgreSQL cluster in Kubernetes. See https://cloudnative-pg.io 

## Install and check

If it's not installed, use `ansible-playbook 440-cnpg.yaml`. Then check:

```
$ kubectl -n cnpg-system  get pods
NAME                                  READY   STATUS    RESTARTS   AGE
cnpg-cloudnative-pg-d74fdd8fb-xtb5v   1/1     Running   0          3m33s

$ kubectl get crds | grep postgres
backups.postgresql.cnpg.io                             2024-05-24T14:20:10Z
clusterimagecatalogs.postgresql.cnpg.io                2024-05-31T13:35:54Z
clusters.postgresql.cnpg.io                            2024-05-24T14:20:11Z
imagecatalogs.postgresql.cnpg.io                       2024-05-31T13:35:56Z
poolers.postgresql.cnpg.io                             2024-05-24T14:20:11Z
scheduledbackups.postgresql.cnpg.io                    2024-05-24T14:20:10Z
```

## Usage

First note we have two storage classes and you can choose between them. Postgres cluster with Longhorn storage class will be safe but slow since they both do replication (so, use it only for very small and critical databases). It's better to use DirectPV and Postgres cluster with 3 reoplicas (one master and two slaves).

As a quick example, you may create those objects:

```
---
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: pg-longhorn
spec:
# two nodes with longhorn storageclass
  instances: 2
  storage:
    storageClass: longhorn
    size: 1Gi
---
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: pg-directpv
spec:
# three nodes with directpv storageclass
  instances: 3
  storage:
    storageClass: directpv-min-io
    size: 1Gi
```

then check the results:

```
$ kubectl get cluster
NAME          AGE   INSTANCES   READY   STATUS                     PRIMARY
pg-directpv   15h   3           3       Cluster in healthy state   pg-directpv-2
pg-longhorn   12h   2           2       Cluster in healthy state   pg-longhorn-1
$ kubectl get pods
NAME            READY   STATUS    RESTARTS      AGE
pg-directpv-1   1/1     Running   1 (11h ago)   15h
pg-directpv-2   1/1     Running   0             15h
pg-directpv-3   1/1     Running   0             15h
pg-longhorn-1   1/1     Running   0             11h
pg-longhorn-2   1/1     Running   0             11h
$ kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
pg-directpv-1   Bound    pvc-1b4d8de8-6256-4ebc-aa98-f2fcec735f3c   1Gi        RWO            directpv-min-io   15h
pg-directpv-2   Bound    pvc-62a6da41-1361-4b3a-9e77-eb72dfa26dc8   1Gi        RWO            directpv-min-io   15h
pg-directpv-3   Bound    pvc-63fdd45c-3685-4cce-85ea-e6341b169889   1Gi        RWO            directpv-min-io   15h
pg-longhorn-1   Bound    pvc-76615ac6-0086-48d0-a8bf-f61191728239   1Gi        RWO            longhorn          12h
pg-longhorn-2   Bound    pvc-18135b7a-0e4f-4388-b97e-2cf3ce53a25d   1Gi        RWO            longhorn          11h
```

## A simple speed test for both postgres clusters

This is very dependent on network and disk speed but in our test environment, postgres using directpv is twice as fast:

```
$ kubectl get cluster
NAME          AGE   INSTANCES   READY   STATUS                     PRIMARY
pg-directpv   15h   3           3       Cluster in healthy state   pg-directpv-2
pg-longhorn   12h   2           2       Cluster in healthy state   pg-longhorn-1

$ kubectl exec -ti pg-directpv-2 -- bash
  postgres@pg-directpv-2:/$ pgbench -i
  [...]
  postgres@pg-directpv-2:/$ pgbench -c 10 -T 60
  [...]
    tps = 418.823352 (without initial connection time)

$ kubectl exec -ti pg-longhorn-1 -- bash
  postgres@pg-longhorn-1:/$ pgbench -i
  [...]
    tps = 190.809707 (without initial connection time)
```

