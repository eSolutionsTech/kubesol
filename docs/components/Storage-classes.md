# Storage classes

Kubesol can provide three StorageClasses. You typically pick one as the cluster **default**; workloads that do not name a class then use that default.

## The three options

### 1. Local path (`local-path`)

Rancher local-path provisioner: dynamic PVCs as directories on the node filesystem. **Enabled by default** in `400-setup-k8s.yaml` (`425-local-path.yaml`). Simple option for single-node or lab setups.

### 2. Longhorn (`longhorn`)

Replicated block storage with a web UI. **Optional** — commented out in `400-setup-k8s.yaml` (`430` / `431` / `432`). Good general-purpose choice when you want redundancy across nodes.

See [Longhorn](longhorn.md).

### 3. DirectPV (`directpv-min-io`)

Local disks managed by MinIO DirectPV. **Optional** — commented out in `400-setup-k8s.yaml` (`440`); needs a dedicated device per worker (`directpv_device` in Inventory). No cross-node replication — the application must handle HA (MinIO, Kafka, multi-replica Postgres, etc.). Faster than Longhorn for those use cases.

See [DirectPV](directpv.md).

## Setting the default StorageClass

Use the helper script at the repo root:

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

Many shipped examples hard-code `longhorn` or `directpv-min-io`. Prefer omitting the field when you want “whatever is currently default.”
