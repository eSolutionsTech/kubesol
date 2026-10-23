# Kubernetes dashboard (deprecated)

The Kubernetes Dashboard is **deprecated and no longer shipped with Kubesol**.

Upstream Kubernetes Dashboard is no longer maintained
(see https://github.com/kubernetes/dashboard). The related Ansible playbooks
(`420-kubernetes-dashboard.yaml`, `422-kubernetes-dashboard-ingress.yaml`) have
been removed from this project.

For a web UI, use other included components such as
[Grafana](monitoring.md), [Argo CD](argocd.md), or [Longhorn](longhorn.md).
