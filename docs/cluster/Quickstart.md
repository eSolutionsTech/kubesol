# Kubesol quickstart

A full production Kubesol setup will require at least 7 VMs (one gateway, 3 controller nodes, 3 worker nodes). 
But may even experiment on a single VM with some limitations.

This procedure will use the same VM as Ansible run host and destination host, that's why we have in 
the Inventory file `ansible_connection=local`. So you just ssh to the VM and run everything there.

## Step by step on DigitalOcean

1. Create a Virtual Machine with Ubuntu Linux 24.04 and 8GB RAM, 4 CPU cores (it will have 150 GB disk but 50GB is enough). 
I have used the name `kubesol-dev4-c1` for the VM.

2. Check that you can ssh on it as root with the ssh key. 
DigitalOcean VMs will have both a public and a private IP. 
Note them down (run `ip a`).

3. We need DNS for SSL certificates so, use the public IP from above and add 2 records to a domain. Something like this:

```
  dev4.YOUR_DOMAIN_COM    PUBLIC_IP
  *.dev4.YOUR_DOMAIN_COM  PUBLIC_IP
```

4. `git clone https://github.com/eSolutionsTech/kubesol.git`

5. install pre-requisites using the `start.sh` script:
```
cd kubesol
./start.sh
```

6. cd into this directory kubesol/ansible and create a file `ansible.cfg`:

```
[defaults]
inventory = Inventory
host_key_checking = False
remote_user = root
remote_port = 22
deprecation_warnings=False 
log_path = .ansible.log
executable = /bin/bash
```

and a file `Inventory` like this (use your hostname, email etc):


```
[all:vars]

D="/root/.kubesol"

rke2_version="v1.37.1+rke2r1"

ext_dns_name="dev4.YOUR_DOMAIN_COM"
letsencrypt_email="EMAIL_FOR_letsencrypt"

longhorn_chart_version="1.13.0"
cert_manager_chart_version="v1.21.2"
argocd_chart_version="10.10.5"
minio_operator_chart_version="7.1.1"
vault_chart_version="0.34.1"
external_secrets_chart_version="2.13.0"
# keycloak_chart_version unset = latest from the Bitnami archive repo
trivy_chart_version="0.37.0"

hosts_gw="kubesol-dev4-c1"

[controller_one]
kubesol-dev4-c1  controller_worker=true ansible_connection=local 
```

7. run `ansible-playbook 200-prep-vms.yaml`. If all ok, continue, else debug and re-run the playbook

8. run `ansible-playbook 300-rke2-cluster.yaml`. This will take 2-3 minutes. If all ok, continue, else debug and re-run the playbook

9. you now have a Kubernetes cluster with one node. you could use it with:

```
$ kubectl get nodes

NAME              STATUS     ROLES                       AGE   VERSION
kubesol-dev4-c1   NotReady   control-plane,etcd,master   78s   v1.37.1+rke2r1
```

Wait until you see the node STATUS Ready.

10. For playbooks >400 we recommend running them one by one and checking status after each one. Note that a full `400-setup-k8s.yaml` run enables only a core set by default; monitoring and many other components stay commented out until you enable them (see [components](../README.md#components)). For example:

## Cert-manager

```
ansible-playbook 410-cert-manager.yaml  # you will need this for ssl certificates
kubectl -n cert-manager get pods        # wait for all pods to be Ready
```

Note: the Kubernetes Dashboard was deprecated and removed from Kubesol
(upstream is no longer maintained). See [kubernetes dashboard](../components/kubernetes-dashboard.md).

## Longhorn storage class

Before installing Longhorn storage class, edit `430-longhorn-prep.yaml` and change `hosts: worker` to `hosts: all`. Then:

```
# edit 430-longhorn-prep.yaml and change hosts: worker to hosts: all
ansible-playbook 430-longhorn-prep.yaml
ansible-playbook 431-longhorn-helm.yaml
ansible-playbook 432-longhorn-web.yaml 

kubectl -n longhorn-system get pods    # check all pods to be Ready
kubectl -n longhorn-system get ingress # get hostname
ansible-playbook 432-longhorn-web.yaml # run the playbook again to see the password
# open in browser
```

## Dummy custom web application
 
In _dummy_ we have an example of a custom web application together with Ingress, SSL certificaties, pods with volumes:

```
ansible-playbook 454-dummy.yaml

kubectl -n dummy get pods
kubectl -n dummy get ingress
kubectl -n dummy get issuer
kubectl -n dummy get certificate
kubectl -n dummy get pvc
# access it in browser
```

If you look again at the longhorn web interface, you will see the volume in the state _Degraded_. This is normal because there are not enough nodes for 3 replicas. But the volume works even without redundancy.

## The monitoring system

Before installing it you will need to run (otherwise `promtail` pod will crash):

```
echo 256 > /proc/sys/fs/inotify/max_user_instances  # default is 128
echo 120000 > /proc/sys/fs/inotify/max_user_watches  # default is 65000
```

The monitoring system will install kube-prometheus-stack and Loki:

```
ansible-playbook 490-kube-prometheus-stack.yaml
ansible-playbook 491-loki.yaml 
ansible-playbook 492-grafana-ingress.yaml 

kubectl -n monitoring get pods
kubectl -n monitoring get ingress

# get the admin password
kubectl -n monitoring get secret grafana-credentials  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

```

Access the web interface and browse, for example, to Dashboards -> Kubernetes / Compute Resources / Cluster.

## That's all for now

Check out our full documentation for more components. Please note some components 
won't work without additional effort in this single-VM case (for example vault).



