# Kubesol

## What is Kubesol

_Kubesol_ is a [free and open-source](../LICENSE.md) Kubernetes distribution
with optional commercial support and / or license by [esolutions.tech](https://www.esolutions.tech/kubesol).

After creating the required Virtual Machines (VMs) and running the installer, you get a Kubernetes cluster with a core set of components enabled by default. Many other popular components are available as optional Ansible playbooks (full list below).

## Here are the main advantages that make our product a standout choice:
- **Free and Open-Source, just as our MOTTO** Enjoy the benefits of a cost-effective solution with the option for premium commercial support if needed.
- **Streamlined Installation**: Simplify your setup with a repeatable installation and configuration process, all driven by efficient Ansible playbooks.
- **Seamless Kubernetes Management**: Easily create and upgrade Kubernetes clusters with the reliable RKE2 system. Learn more at RKE2 GitHub.
- **Pre-Configured Storage Classes**: Benefit from Longhorn and DirectPV (enabled by default in `400-setup-k8s.yaml`; DirectPV needs extra disks on workers).
- **Comprehensive Kubernetes Components**: Core components are enabled by default; others are optional playbooks you can uncomment or run separately. See the full list below.
- **Extensive Documentation**: Access detailed documentation and example usage guides for a wide range of components, ensuring you have all the support you need.
- **User-Friendly**: Operate with ease, requiring only minimal knowledge of Ansible, kubectl, and Helm, making it accessible even for DevOps professionals with limited experience.

See also the [FAQ](FAQ.md) and [Troubleshooting Guide](troubleshooting.md) for help with common issues.

## Usage

- [quickstart with a single VM](cluster/Quickstart.md)
- [create a new cluster](cluster/create-new-cluster.md)
- [use an existing cluster](cluster/use-existing-cluster.md)
- [adding more worker nodes](cluster/adding-nodes.md)
- [upgrade an existing cluster](cluster/upgrade-cluster.md)

## Advanced troubleshooting
- [etcd rejoin](cluster/etcd-rejoin.md)
- [reset/delete an existing cluster](cluster/reset-cluster.md)
- [etcd backup/restore](cluster/etcd-backup-restore.md) and more debugging [etcd commands](cluster/etcd-commands.md).

## Components

What runs after `ansible-playbook 000-all.yaml` (or `400-setup-k8s.yaml`) depends on which imports are enabled in [ansible/400-setup-k8s.yaml](../ansible/400-setup-k8s.yaml). Uncomment a line there, or run the playbook yourself.

### Enabled by default in `400-setup-k8s.yaml`

- [Cert-manager](components/cert-manager.md)
- [longhorn](components/longhorn.md) storage class with web interface
- [DirectPV](components/directpv.md) storage class (needs a dedicated disk per worker; see Inventory `directpv_device`)
- [Examples](components/examples.md) demo apps (simple pod / PVC / dummy web app)
- [VPA Vertical Pod Autoscaler](components/vpa.md) and Goldilocks

### Bundled with RKE2 (not separate Kubesol playbooks)

- [metrics-server](components/kubernetes-metrics-server.md)
- [Ingress controller (Traefik, nginx Ingress class)](components/nginx-ingress-controller.md)

### Optional (commented out in `400-setup-k8s.yaml`)

- [local-path provisioner](https://github.com/rancher/local-path-provisioner) — playbook `425-local-path.yaml` (handy for simple / single-node setups instead of Longhorn)
- [monitoring](components/monitoring.md) — Prometheus, AlertManager, Grafana, Loki (`490` / `491` / `492`)
- [keycloak](components/keycloak.md) (`470`; needs CNPG)
- [ArgoCD](components/argocd.md) (`500`)
- [Minio operator](components/minio.md) (`530`; needs DirectPV)
- [Strimzi (Kafka) operator](components/strimzi-kafka.md) (`520`)
- [PostgreSQL operator](components/postgres-cnpg.md) CNPG (`460`)
- [Velero](components/velero.md) (`480`)
- [Trivy](components/trivy.md) (`510` / `511`)
- [Vault](components/vault.md) and [External Secrets Operator](components/external-secrets.md) (`550` / `560`)

### Deprecated / removed

- [kubernetes dashboard](components/kubernetes-dashboard.md) — upstream no longer maintained; playbooks removed

Some optional components have dependencies (for example Keycloak → CNPG → storage class; MinIO → DirectPV).

## For Developers

If you're contributing to Kubesol or extending its functionality, check out our [Developer Notes](developer-notes.md) for technical insights and best practices.


