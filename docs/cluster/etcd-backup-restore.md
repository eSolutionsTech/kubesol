# Etcd backup restore procedures

Read https://docs.rke2.io/backup_restore

Snapshots are enabled (by default at every 12 hours and retain last 5). 

The snapshot directory defaults to `/var/lib/rancher/rke2/server/db/snapshots` or you can list snapshots with `rke2 etcd-snapshot ls`.

You can manually take a snapshot with `rke2 etcd-snapshot save --name some-name`.


## To restore from a snapshot:

1. Stop ALL master nodes `systemctl stop rke2-server`.
2. Only on one of the masters, restore etcd database with `rke2 server --cluster-reset --cluster-reset-restore-path=<PATH-TO-SNAPSHOT>`.
3. Start this first master `systemctl start rke2-server`.
4. On the rest of the master nodes, ONE BY ONE, delete old etcd database with `rm -rf /var/lib/rancher/rke2/server/db` then start the server with `systemctl start rke2-server`. This will cause the new etcd member to join and sync from the first node. Check node status with `kubectl get nodes` and allow time for every node to become `Ready`.
5. After all master nodes are `Ready`, worker nodes should recover after 5 minutes. You can speed this up by restarting them, one by one, with `systemctl restart rke2-agent`.

