# Kubesol FAQ

**Why yet another Kubernetes distribution?**

This is the open-source world. Why there are so many Linux distributions? If you like it, use it. We are using it at our company.

**Why not using Ansible roles?**

One of our guiding principles is to keep this as simple and easy to understand possible, even for a junior Devops Engineer. 
Even though Ansible roles are good for modularity and hide complexity, they are not good at encouraging deep understanding of how things work.

**Why wouldn't I use the official RKE2 installer?**

By all means, do it. But in our Ansible playbooks we have included a lot of knowledge for solving some problems, 
results from repeating the official installation and upgrade methods many times (and this is not only for RKE2 but for other components).

Also we think our documentation is very good for a quick start with many Kubernetes components.

**Why do you offer commercial support, isn't this totally free?**

Yes, it is totally free to use it. Only the support is commercial, like, for example in Ubuntu Linux.

**Traefik or nginx — which Ingress controller do we use?**

**Inside** the cluster, RKE2 runs **Traefik**. Kubesol configures Traefik’s Kubernetes Ingress NGINX provider and sets IngressClass **`nginx`** as the only default, so existing manifests that use `ingressClassName: nginx` (or omit the class and rely on the default) keep working. Traefik’s own class `traefik` exists but is not the default. See [Ingress (Traefik)](components/traefik-ingress.md).

**Is the gateway “nginx” the same as IngressClass nginx?**

No. On multi-node installs, the **gateway** VM runs host **nginx** as an outer reverse proxy (`280-gw.yaml`). That is separate from the in-cluster Traefik / IngressClass `nginx` story. Single-VM quickstart has no separate gateway.

**Do optional charts need Longhorn?**

No. Monitoring, Loki, Trivy, and Vault omit `storageClass` / `storageClassName` so they use the **cluster default** (usually `local-path` after `425`). Commented `longhorn` lines remain in those values if you want to pin Longhorn later. See [Storage classes](components/Storage-classes.md).

**When should I re-run `407` or `425` / `default-sc.sh`?**

- `ansible-playbook 407-ingressclass-defaults.yaml` — after Traefik / IngressClass changes, or if `kubectl get ingressclass` shows more than one `(default)` or Traefik as default. It waits for Traefik’s class and fails if `nginx` is not the sole default.
- `ansible-playbook 425-local-path.yaml` — installs local-path and marks it default (also part of a full `400`).
- `./default-sc.sh` / `./default-sc.sh <name>` — list or change the default StorageClass later (for example after enabling Longhorn or DirectPV).
