# DirectPV

DirectPV is a storage class used by default by Minio: https://min.io/directpv

Unlike Longhorn, DirectPV doesn't replicate the volumes so that must be done at the application level. This means if a node is down, the volume on that node is down and the application must handle the problem.

Good use cases are: Minio, Kafka, Zookeeper, PostgreSQL with replicas. 

## Installation

DirectPV is **optional** (commented out in `400-setup-k8s.yaml`). Uncomment `440-directpv.yaml` when workers have a dedicated disk. In our setup it is required by MinIO. Set `directpv_device` in Inventory to that extra disk (never the OS disk).

`440-directpv.yaml` discovers drives and prints `/root/.kubesol/.drives.yaml`. On the first run it then pauses so you can confirm at least one dedicated disk per node is listed. Press return to initialize those drives, or Ctrl+C and then `a` to abort. Later runs skip the pause and `init` because `.drives.init` already exists. Make sure the worker nodes are **Ready** before you run it.

## Uninstall / cleanup

`ansible-playbook 449-Uninstall-directpv.yaml` removes DirectPV and the files under `/root/.kubesol`. On workers, and on a single-node host marked `controller_worker=true`, it unmounts and wipes `directpv_device` when that variable is set. It refuses to wipe the disk that holds `/`.

## Check status

You must see something like this:

```
$ kubectl get storageclasses
NAME                 PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default) rancher.io/local-path   Delete          WaitForFirstConsumer   false                  1d
directpv-min-io      directpv-min-io         Delete          WaitForFirstConsumer   true                   6d23h
# Cluster default stays local-path unless you run ./default-sc.sh (or enable Longhorn and set it default).

# note one controller and one node-server for each worker node
$ kubectl -n directpv get pods
NAME                          READY   STATUS    RESTARTS       AGE
controller-67f8b6b459-4fvgp   3/3     Running   5 (66m ago)    6d4h
controller-67f8b6b459-5z4gr   3/3     Running   1 (23h ago)    6d4h
controller-67f8b6b459-rgggj   3/3     Running   2 (3d1h ago)   6d4h
node-server-2cl6k             4/4     Running   0              6d23h
node-server-hxjxb             4/4     Running   4 (6d2h ago)   6d23h
node-server-tz9v4             4/4     Running   0              6d23h

# a list of PVC using directpv storage class
$ kubectl get pvc -A | grep directpv
[...]
```

## Other directpv informational commands

Again on `c1` node you may use those `kubectl-directpv` commands:

```
# kubectl-directpv info
┌───────────┬──────────┬───────────┬─────────┬────────┐
│ NODE      │ CAPACITY │ ALLOCATED │ VOLUMES │ DRIVES │
├───────────┼──────────┼───────────┼─────────┼────────┤
│ • w1-dev5 │ 20 GiB   │ 0 B       │ 0       │ 1      │
│ • w2-dev5 │ 20 GiB   │ 0 B       │ 0       │ 1      │
│ • w3-dev5 │ 20 GiB   │ 10 MiB    │ 1       │ 1      │
└───────────┴──────────┴───────────┴─────────┴────────┘

10 MiB/60 GiB used, 1 volumes, 3 drives


# kubectl-directpv list drives
┌─────────┬──────┬───────────┬────────┬────────┬─────────┬────────┐
│ NODE    │ NAME │ MAKE      │ SIZE   │ FREE   │ VOLUMES │ STATUS │
├─────────┼──────┼───────────┼────────┼────────┼─────────┼────────┤
│ w1-dev5 │ sdb  │ DO Volume │ 20 GiB │ 20 GiB │ -       │ Ready  │
│ w2-dev5 │ sdb  │ DO Volume │ 20 GiB │ 20 GiB │ -       │ Ready  │
│ w3-dev5 │ sdb  │ DO Volume │ 20 GiB │ 20 GiB │ 1       │ Ready  │
└─────────┴──────┴───────────┴────────┴────────┴─────────┴────────┘


# kubectl-directpv list volumes
┌──────────────────────────────────────────┬──────────┬─────────┬───────┬────────────────┬──────────────┬─────────┐
│ VOLUME                                   │ CAPACITY │ NODE    │ DRIVE │ PODNAME        │ PODNAMESPACE │ STATUS  │
├──────────────────────────────────────────┼──────────┼─────────┼───────┼────────────────┼──────────────┼─────────┤
│ pvc-6194b697-22b1-4410-9f37-6fdd74618422 │ 10 MiB   │ w3-dev5 │ sdb   │ simple-pod-pvc │ default      │ Bounded │
└──────────────────────────────────────────┴──────────┴─────────┴───────┴────────────────┴──────────────┴─────────┘
```

