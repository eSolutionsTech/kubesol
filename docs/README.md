# Kubesol

## What is Kubesol

_Kubesol_ is a [free and open-source](../LICENSE.md) Kubernetes distribution
with optional commercial support by [esolutions.tech](https://www.esolutions.tech/kubesol).

After creating the required Virtual Machines (VMs) and running the installer, the end product is a Kubernetes cluster with many useful and popular components installed (full list below).

## Here are the main advantages that make our product a standout choice:
- **Free and Open-Source, just as our MOTTO** Enjoy the benefits of a cost-effective solution with the option for premium commercial support if needed.
- **Streamlined Installation**: Simplify your setup with a repeatable installation and configuration process, all driven by efficient Ansible playbooks.
- **Seamless Kubernetes Management**: Easily create and upgrade Kubernetes clusters with the reliable RKE2 system. Learn more at RKE2 GitHub.
- **Pre-Configured Storage Classes**: Benefit from built-in Longhorn and DirectPV storage classes, ready to go out of the box.
- **Comprehensive Kubernetes Components**: Start with the most common Kubernetes components already configured, saving you time and effort. See the full list below.
- **Extensive Documentation**: Access detailed documentation and example usage guides for a wide range of components, ensuring you have all the support you need.
- **User-Friendly**: Operate with ease, requiring only minimal knowledge of Ansible, kubectl, and Helm, making it accessible even for DevOps professionals with limited experience.

See also the [FAQ](FAQ.md).

## Usage

- [quickstart with a single VM](cluster/Quickstart.md)
- [create a new cluster](cluster/create-new-cluster.md)
- [use an existing cluster](cluster/use-existing-cluster.md).
- [upgrade an existing cluster](cluster/upgrade-cluster.md)
- [reset/delete an existing cluster](cluster/reset-cluster.md)
- [etcd backup/restore](cluster/etcd-backup-restore.md) and more debugging [etcd commands](cluster/etcd-commands.md).

## Included components

The following components are included and we have documentation on how to use them:

- [Cert-manager](components/cert-manager.md)
- [kubernetes dashboard](components/kubernetes-dashboard.md) web interface
- [metrics-server](components/kubernetes-metrics-server.md)
- [nginx ingress controller](components/nginx-ingress-controller.yaml)
- [longhorn](components/longhorn.md) storage class with web interface
- [monitoring](components/monitoring.md) with web interface (Prometheus, AlertManager, Grafana, Grafana Loki)
- [keycloak](components/keycloak.md) with web interface
- [ArgoCD](components/argocd.md) with web interface
- [Examples](components/examples.md) demo for a full web app with yaml manifests, storage, ingress, ssl certificate
- [DirectPV](components/directpv.md) storage class
- [Minio operator](components/minio.md) (with web interface) for S3 compatible buckets
- [Strimzi (Kafka) operator](components/strimzi-kafka.md)
- [PostgreSQL operator](components/postgres-cnpg.md) CNPG
- [Velero](components/velero.md) backup system
- [Trivy](components/trivy.md) security scanner
- [Vault](components/vault.md) and [External Secrets Operator](components/external-secrets.md)
- [VPA Vertical Pod Autoscaler](components/vpa.md)


The components are optional and you may choose to skip some of them (but there are some dependencies).


