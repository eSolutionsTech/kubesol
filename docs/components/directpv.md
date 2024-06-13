# DirectPV

DirectPV is a storage class used by default by Minio: https://min.io/directpv

Unlike Longhorn, DirectPV don't replicate the volumes so that must be done at the application level. This means if a node is down, the volume on that node is down and the application must handle the problem.

Good use cases are: Minio, Kafka, Zookeeper, PostgreSQL with replicas. 

## Installation

In our setup, DirectPV is required by minio.

This is difficult to install, even using our Ansible playbook. Please make sure
- all the worker nodes are __Ready__ before running `ansible-playbook 420-directpv.yaml`
- when Ansible shows the message __Check .drives.yaml now!__ you really check that file (in another terminal), making sure at least one block device per worker nodes is in that file!

## Uninstall / cleanup

If you wish to uninstall DirectPV, we recommend using `ansible-playbook 429-Uninstall-directpv.yaml` for a clean job.

## Check status

You must see something like this:

```
$ kubectl get storageclasses
NAME                 PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
directpv-min-io      directpv-min-io      Delete          WaitForFirstConsumer   true                   6d23h
longhorn (default)   driver.longhorn.io   Delete          Immediate              true                   6d23h

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

