# Kubesol quickstart

A full production Kubesol setup needs several VMs (gateway, controllers, workers).
You can also experiment on a **single VM** with limitations (no HA, no separate gateway).

This procedure uses the same VM as Ansible control host and target (`ansible_connection=local` in Inventory). SSH to the VM and run everything there. There is no separate gateway host in this single-VM path.

## Step by step on DigitalOcean

1. Create a Virtual Machine with Ubuntu Linux 24.04 and 8GB RAM, 4 CPU cores (150 GB disk is fine; ~50 GB is enough).
   Example hostname: `kubesol-dev4-c1`.

2. Check that you can SSH in as root with your key.
   DigitalOcean VMs have a public and a private IP — note them (`ip a`).

3. DNS for TLS: point these at the public IP:

```
  dev4.YOUR_DOMAIN_COM    PUBLIC_IP
  *.dev4.YOUR_DOMAIN_COM  PUBLIC_IP
```

4. Clone the repo:

```
git clone https://github.com/eSolutionsTech/kubesol.git
```

5. Install prerequisites:

```
cd kubesol
./start.sh
```

`start.sh` installs Ansible packages and, if missing, copies `ansible.cfg-example` → `ansible.cfg` and a starter Inventory. For this single-VM path, use the single-node example:

```
cd ansible
cp Inventory-single-node-example Inventory
```

6. Edit `Inventory` (hostname, DNS, email). Example:

```
[all:vars]

rke2_version="v1.37.1+rke2r1"

D="/root/.kubesol"

ext_dns_name="dev4.YOUR_DOMAIN_COM"
letsencrypt_email="EMAIL_FOR_letsencrypt"

hosts_gw="kubesol-dev4-c1"

[controller_one]
kubesol-dev4-c1  controller_worker=true ansible_connection=local
```

Optional chart pins (`*_chart_version`) are documented under [version variables](version-variables.md). Leave them unset to install the latest chart versions.

7. Prepare the VM:

```
ansible-playbook 200-prep-vms.yaml
```

8. Install the RKE2 cluster (2–3 minutes):

```
ansible-playbook 300-rke2-cluster.yaml
```

9. Check the node:

```
$ kubectl get nodes

NAME              STATUS   ROLES                       AGE   VERSION
kubesol-dev4-c1   Ready    control-plane,etcd,master   78s   v1.37.1+rke2r1
```

Wait until STATUS is Ready.

10. For playbooks after `300`, prefer running them one by one.
    A full `400-setup-k8s.yaml` enables **cert-manager**, **local-path**, and **demo apps** by default.
    Longhorn, monitoring, and most other stacks stay commented out until you enable them
    (see [components](../README.md#components)).

## Default path: cert-manager, local-path, demos

```
ansible-playbook 410-cert-manager.yaml
kubectl -n cert-manager get pods   # wait until Ready

ansible-playbook 425-local-path.yaml
kubectl get storageclass           # expect local-path (default)

# Optional: list or change the default later from the repo root
# ../default-sc.sh
# ../default-sc.sh longhorn

ansible-playbook 454-dummy.yaml
kubectl -n dummy get pods,ingress,pvc
# open https://dummy.<ext_dns_name> when DNS and certificates are ready
```

The dummy app PVC omits `storageClassName`, so it uses the cluster default (local-path unless you changed it). See [Storage classes](../components/Storage-classes.md) and [Examples](../components/examples.md).

In-cluster Ingress is **Traefik**, with IngressClass **`nginx`** as default. A full `400` runs `407-ingressclass-defaults.yaml` to enforce that; re-run `407` alone if defaults look wrong. See [Ingress controller](../components/traefik-ingress.md).

## Optional: Longhorn

Only if you want replicated storage (not required for the default demos). `430-longhorn-prep.yaml` already includes a single-node host with `controller_worker=true`. Optionally set `longhorn_device` in Inventory to a dedicated disk (never the OS disk). Then:

```
ansible-playbook 430-longhorn-prep.yaml
ansible-playbook 431-longhorn-helm.yaml
ansible-playbook 432-longhorn-web.yaml

kubectl -n longhorn-system get pods
kubectl -n longhorn-system get ingress
# run 432 again to print the UI password
```

With one node, Longhorn volumes may show as *Degraded* (not enough replicas). That is expected.

Then you can make Longhorn the default: `../default-sc.sh longhorn`.

## Optional: monitoring

Monitoring uses the cluster default StorageClass and does not need Longhorn. Also raise inotify limits (otherwise Promtail may crash):

```
echo 256 > /proc/sys/fs/inotify/max_user_instances
echo 120000 > /proc/sys/fs/inotify/max_user_watches

ansible-playbook 490-kube-prometheus-stack.yaml
ansible-playbook 491-loki.yaml
ansible-playbook 492-grafana-ingress.yaml

kubectl -n monitoring get pods,ingress
kubectl -n monitoring get secret grafana-credentials -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## That's all for now

See the [full documentation](../README.md) for more components. Some stacks need extra work on a single VM (for example Vault).
