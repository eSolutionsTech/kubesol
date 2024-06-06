# Kubesol

## What is Kubesol

**Kubesol** is a Kubernetes distribution, free and open-source but with optional commercial support by [eSolutions.tech](https://www.esolutions.tech/kubesol). After creating the required Virtual Machines (VMs) and running the installer, the end product is a Kubernetes cluster with many useful and popular components installed (full list below).

Some of the advantages are:
- It is free and open-source but with optional commercial support
- Very easy to be understood and operate by a DevOps Engineer with minimal knowledge on Ansible, kubectl, Helm (and nothing more).
- It simplifies and makes the installation and configuration process repeatable - all operations are based on Ansible playbooks.
- It can create and upgrade Kubernetes clusters based on RKE2 - https://github.com/rancher/rke2
- It comes with two pre-configured storage classes: Longhorn and DirectPV.
- It comes with most usual Kubernetes components pre-configured, see list below
- It has documentation and example usage for many components

See also the [FAQ](FAQ.md).

## Usage

- [quickstart with a single VM](cluster/Quickstart.md)
- [create a new cluster](cluster/create-new-cluster.md)
- [use an existing cluster](cluster/use-existing-cluster.md). Short version: to run kubectl commands just `export KUBECONFIG=.kubeconfig` then run kubectl/helm commands targetting the cluster.
- [upgrade an existing cluster](cluster/upgrade-cluster.md)
- [reset/delete an existing cluster](cluster/reset-cluster.md)
- [etcd backup/restore](cluster/etcd-backup-restore.md) and more debugging [etcd commands](cluster/etcd-commands.md).

## Included components

The following components are included and we have documentation on how to use them:

- [kubernetes dashboard](components/kubernetes-dashboard.md) web interface
- [metrics-server](components/kubernetes-metrics-server.md)
- [nginx ingress controller](components/nginx-ingress-controller.yaml)
- [longhorn](components/longhorn.md) storage class with web interface
- [monitoring](components/monitoring.md) with web interface (Prometheus, AlertManager, Grafana, Grafana Loki)
- [keycloak](components/keycloak.md) with web interface
- [ArgoCD](components/argocd.md) with web interface
- [Cert-manager](components/cert-manager.md)
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


