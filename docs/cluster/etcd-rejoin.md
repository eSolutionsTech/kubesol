# etcd rejoin

If the etcd database gets corrupted on one controller node (for example by an unclean shutdown)
but the other two controllers are running ok, you can *reset* the database on the failing controller.
This is easier than the etcd backup-restore procedure.

## Detect the problem

You will see `systemctl start|restart rke2-server` taking a very long time and 
never finishing. The logs from systemctl (`journalctl -u rke2-server`) 
are not very useful but they will say something like `etcd not ready`.

You can use those commands to really confirm the etcd problem:

```
/var/lib/rancher/rke2/bin/crictl -r unix:///run/k3s/containerd/containerd.sock ps -a | grep etcd 
# you wil see the container continuosly restarting

/var/lib/rancher/rke2/bin/crictl -r unix:///run/k3s/containerd/containerd.sock logs <CONTAINER_ID>
# you will see messages about corrupted files/database
```

## etcdctl

You will need the `etcdctl` binary. On Ubuntu you can installing it with `apt install etcd-client`. 

## Repairing the problem

If you have 2 controllers ok and one failing, you can basically 
delete the etcd database from the broken 
one and let it re-synchronize from the other two. 
This is the step by step procedure for RKE2:

```
### steps below must be run on a working controller

# check the status
kubectl get nodes

# check the etcd members
export ETCDCTL_API=3
/usr/bin/etcdctl \
  --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
  --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
  --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
  --endpoints=https://127.0.0.1:2379 \
  member list

# remove the not-healthy node - get the ID from the above command
export ETCDCTL_API=3
/usr/bin/etcdctl \
  --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
  --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
  --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
  --endpoints=https://127.0.0.1:2379 \
  member remove <MEMBER_ID>

### steps below on the failing controller

# stop the service
systemctl stop rke2-server

# cleanup the etcd database # mv or rm
mv /var/lib/rancher/rke2/server/db/etcd /tmp 

# check rke2 config
cat /etc/rancher/rke2/config.yaml

# start the service
systemctl start rke2-server
```

The node will start and re-sync the etcd database.

## The result

 You can check later with

```
kubectl get nodes
journalctl -u rke2-server -f

# verify etcd membership
export ETCDCTL_API=3
/usr/bin/etcdctl \
  --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
  --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
  --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key \
  --endpoints=https://127.0.0.1:2379 \
  member list

```

## eof


