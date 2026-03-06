# Etcd backup restore procedures

Read https://docs.rke2.io/datastore/backup_restore

Snapshots are enabled (by default at every 12 hours and retain last 5). 

The snapshot directory defaults to `/var/lib/rancher/rke2/server/db/snapshots` or you can list snapshots with `rke2 etcd-snapshot ls`.

You can manually take a snapshot with `rke2 etcd-snapshot save --name some-name`.


## To restore from a snapshot:

1. Stop ALL master nodes `systemctl stop rke2-server`.
2. Only on one of the masters, restore etcd database with `rke2 server --cluster-reset --cluster-reset-restore-path=<PATH-TO-SNAPSHOT>`.
   - If restore fails with `cannot perform cluster-reset while server URL is set`, temporarily comment `server: https://<your-server>:9345` in the node config, run restore again, then uncomment it. The cluster-reset command refuses to run if the node is still configured to join an existing server via server.
3. Start this first master `systemctl start rke2-server`.
4. On the rest of the master nodes, ONE BY ONE, delete old etcd database with `rm -rf /var/lib/rancher/rke2/server/db` then start the server with `systemctl start rke2-server`. This will cause the new etcd member to join and sync from the first node. Check node status with `kubectl get nodes` and allow time for every node to become `Ready`.
5. After all master nodes are `Ready`, worker nodes should recover after 5 minutes. You can speed this up by restarting them, one by one, with `systemctl restart rke2-agent`.

## Example

Incident: `kdev3-c1` was `NotReady`.

1. On healthy controller `kdev3-c2`, list snapshots:

```bash
rke2 etcd-snapshot ls
```

Example output (trimmed):

```text
etcd-snapshot-kdev3-c2-1772748002                 file:///var/lib/rancher/rke2/server/db/snapshots/etcd-snapshot-kdev3-c2-1772748002                 211517472 2026-03-06T00:00:02+02:00
on-demand-kdev3-c1-1772787806-kdev3-c2-1772787808 file:///var/lib/rancher/rke2/server/db/snapshots/on-demand-kdev3-c1-1772787806-kdev3-c2-1772787808 211517472 2026-03-06T11:03:28+02:00
```

2. Create a fresh on-demand snapshot:

```bash
rke2 etcd-snapshot save --name on-demand-kdev3-c1-$(date +%s)
```

3. Stop `rke2-server` on all controller nodes:

```bash
systemctl stop rke2-server.service
```

4. Restore on `kdev3-c2`:

```bash
rke2 server --cluster-reset --cluster-reset-restore-path=/var/lib/rancher/rke2/server/db/snapshots/on-demand-kdev3-c1-1772787806-kdev3-c2-1772787808
```

First attempt failed with:

```text
FATA[0030] Error: cannot perform cluster-reset while server URL is set - remove server from configuration before resetting
```

Fix:
- Temporarily comment this line in config: `server: https://kdev3-gw:9345`
- Re-run the restore command
- Uncomment `server: https://kdev3-gw:9345`

5. Start `rke2-server` on `kdev3-c2`:

```bash
systemctl start rke2-server.service
```

6. On `kdev3-c1` and `kdev3-c3`, remove old etcd db:

```bash
rm -rf /var/lib/rancher/rke2/server/db
```

7. Start `rke2-server` on `kdev3-c3` and `kdev3-c1`, one by one.

8. Validate recovery:

```bash
kubectl get nodes
```

Expected result: all nodes are `Ready`.
