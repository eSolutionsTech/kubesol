# Kubesol

## What is Kubesol

_Kubesol_ is a [free and open-source](../LICENSE.md) Kubernetes distribution
with optional commercial support and / or license by [esolutions.tech](https://www.esolutions.tech/kubesol).

After creating the required Virtual Machines (VMs) and running the installer, you get a Kubernetes cluster with a core set of components enabled by default. Many other popular components are available as optional Ansible playbooks (full list below).

## Here are the main advantages that make our product a standout choice:
- **Free and Open-Source, just as our MOTTO** Enjoy the benefits of a cost-effective solution with the option for premium commercial support if needed.
- **Streamlined Installation**: Simplify your setup with a repeatable installation and configuration process, all driven by efficient Ansible playbooks.
- **Seamless Kubernetes Management**: Easily create and upgrade Kubernetes clusters with the reliable [RKE2](https://github.com/rancher/rke2) system.
- **Pre-Configured Storage Classes**: Local-path is enabled by default; Longhorn and DirectPV are optional (uncomment in `400-setup-k8s.yaml`; DirectPV needs extra disks on workers).
- **Comprehensive Kubernetes Components**: A small core set is enabled by default; others are optional playbooks you can uncomment or run separately. See the full list below.
- **Extensive Documentation**: Access detailed documentation and example usage guides for a wide range of components, ensuring you have all the support you need.
- **User-Friendly**: Operate with ease, requiring only minimal knowledge of Ansible, kubectl, and Helm, making it accessible even for DevOps professionals with limited experience.

See also the [FAQ](FAQ.md) and [Troubleshooting Guide](troubleshooting.md) for help with common issues.

## Usage

- [quickstart with a single VM](cluster/Quickstart.md)
- [create a new cluster](cluster/create-new-cluster.md)
- [use an existing cluster](cluster/use-existing-cluster.md)
- [adding more worker nodes](cluster/adding-nodes.md)
- [upgrade an existing cluster](cluster/upgrade-cluster.md)
- [version variables](cluster/version-variables.md) (RKE2, Helm charts, `*_chart_version`)
- [accessing web interfaces](cluster/accessing-web-interfaces.md)

## Advanced troubleshooting
- [etcd rejoin](cluster/etcd-rejoin.md)
- [reset/delete an existing cluster](cluster/reset-cluster.md)
- [etcd backup/restore](cluster/etcd-backup-restore.md) and more debugging [etcd commands](cluster/etcd-commands.md).

## Components

What runs after `ansible-playbook 000-all.yaml` (or `400-setup-k8s.yaml`) depends on which imports are enabled in [ansible/400-setup-k8s.yaml](../ansible/400-setup-k8s.yaml). Uncomment a line there, or run the playbook yourself.

### Enabled by default in `400-setup-k8s.yaml`

- [Cert-manager](components/cert-manager.md)
- [local-path](components/Storage-classes.md) storage class (`425-local-path.yaml`)
- [Examples](components/examples.md) demo apps (simple pod / PVC / dummy web app)

See also [Storage classes](components/Storage-classes.md) (Longhorn / DirectPV / local-path) and `./default-sc.sh` at the repo root to list or set the default StorageClass.

### Bundled with RKE2 (not separate Kubesol playbooks)

- [metrics-server](components/kubernetes-metrics-server.md)
- [Ingress controller (Traefik, nginx Ingress class)](components/traefik-ingress.md)

### Optional (commented out in `400-setup-k8s.yaml`)

- [longhorn](components/longhorn.md) (`430` / `431` / `432`; optional `433-longhorn-rf1.yaml` for a single-replica class)
- [DirectPV](components/directpv.md) (`440`; needs a dedicated disk per worker)
- [monitoring](components/monitoring.md) — Prometheus, AlertManager, Grafana, Loki (`490` / `491` / `492`; uninstall: `499` / `498`)
- [keycloak](components/keycloak.md) (`470`; needs CNPG)
- [ArgoCD](components/argocd.md) (`500`)
- [Minio operator](components/minio.md) (`530`; needs DirectPV)
- [Strimzi (Kafka) operator](components/strimzi-kafka.md) (`520`)
- [PostgreSQL operator](components/postgres-cnpg.md) CNPG (`460`)
- [Velero](components/velero.md) (`480`)
- [Trivy](components/trivy.md) (`510` / `511` Grafana dashboard ConfigMap)
- [VPA Vertical Pod Autoscaler](components/vpa.md) and Goldilocks (`540` / `542`)
- [Vault](components/vault.md) and [External Secrets Operator](components/external-secrets.md) (`550` / `560`)

### Deprecated / removed

- [kubernetes dashboard](components/kubernetes-dashboard.md) — upstream no longer maintained; playbooks removed

### Component dependencies

```
Keycloak ──needs──> CNPG ──needs──> a StorageClass (default or Longhorn/DirectPV)
MinIO    ──needs──> DirectPV (extra disks on workers)
Monitoring / Loki / Trivy / Vault Helm values often pin storageClass: longhorn
  └── enable Longhorn, change the values, or use ./default-sc.sh + omit storageClass where possible
Dummy / simple PVCs that omit storageClassName use the cluster default (local-path by default)
```

## Versions and tools

- Example RKE2 pin in docs/Inventory: `v1.37.1+rke2r1` (see [version variables](cluster/version-variables.md) and [upgrade](cluster/upgrade-cluster.md))
- Helm CLI installed by `290-c1.yaml` as **v3.22.1** (`HELM_ARCHIVE`)
- Tested OS: Ubuntu 22.04 and 24.04
- Chart versions: leave `*_chart_version` unset for latest, or pin in Inventory

## For Developers

If you're contributing to Kubesol or extending its functionality, check out our [Developer Notes](developer-notes.md) for technical insights and best practices.
