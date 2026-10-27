# Storage classes

Kubesol can provide three StorageClasses. You typically pick one as the cluster **default**; workloads that do not name a class then use that default.

## The three options

### 1. Local path (`local-path`)

Rancher local-path provisioner: dynamic PVCs as directories on the node filesystem. **Enabled by default** in `400-setup-k8s.yaml` (`425-local-path.yaml`), which also marks `local-path` as the cluster default StorageClass. Simple option for single-node or lab setups.

### 2. Longhorn (`longhorn`)

Replicated block storage with a web UI. **Optional** — commented out in `400-setup-k8s.yaml` (`430` / `431` / `432`). Good general-purpose choice when you want redundancy across nodes.

See [Longhorn](longhorn.md).

### 3. DirectPV (`directpv-min-io`)

Local disks managed by MinIO DirectPV. **Optional** — commented out in `400-setup-k8s.yaml` (`440`); needs a dedicated device per worker (`directpv_device` in Inventory). No cross-node replication — the application must handle HA (MinIO, Kafka, multi-replica Postgres, etc.). Faster than Longhorn for those use cases.

See [DirectPV](directpv.md).

## Setting the default StorageClass

A default install runs `425-local-path.yaml`, which installs local-path and marks it as the cluster default. To list or change the default later, use the helper script at the repo root:

```
# List StorageClasses (shows which one is default)
./default-sc.sh

# Make longhorn the only default
./default-sc.sh longhorn

# Make DirectPV the default
./default-sc.sh directpv-min-io

# Unknown name → script only lists classes (does not change anything)
./default-sc.sh nosuch
```

The script clears `storageclass.kubernetes.io/is-default-class` on all classes, then sets it on the name you pass (if that StorageClass exists). Run it from a host with a working `kubectl` context (usually `controller_one`).

Check with:

```
kubectl get storageclass
```

The default class is marked `(default)` in the list.

## Using the default in examples and manifests

If a PVC (or a CRD field such as CNPG `storage.storageClass`) **omits** `storageClassName` / `storageClass`, Kubernetes uses the cluster default StorageClass.

So in examples you can leave out that parameter to follow whatever you set with `./default-sc.sh`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  # no storageClassName: → uses the default StorageClass
```

If you **set** a specific class, that class is used instead of the default:

```yaml
  storageClassName: longhorn
  # or, in some operators:
  # storageClass: directpv-min-io
```

Shipped Helm values omit the class so they follow the cluster default. Commented `longhorn` lines in those values are optional. Prefer omitting the field when you want “whatever is currently default.”

## Related playbooks

| Playbook | StorageClass |
|---|---|
| `425-local-path.yaml` | `local-path` (enabled + set as default in `400-setup-k8s.yaml`) |
| `430` / `431` / `432` | `longhorn` (+ UI) |
| `433-longhorn-rf1.yaml` | `longhorn-rf1` (1 replica; after Longhorn is installed) |
| `440-directpv.yaml` | `directpv-min-io` |
