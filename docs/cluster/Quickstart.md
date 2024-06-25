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

4. ssh into VM and install some tools (as root): 

```
apt update -y
apt install ansible python3-kubernetes pwgen -y

ansible-galaxy collection install kubernetes.core
```

5. `git clone https://github.com/eSolutionsTech/kubesol.git`

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
rke2_version="v1.29.4+rke2r1"

ext_dns_name="dev4.YOUR_DOMAIN_COM"
letsencrypt_email="EMAIL_FOR_letsencrypt"

longhorn_version="1.6.1"
certmanager_version="v1.14.4"
argocd_chart_version="7.0.0"
minio_operator_chart_version="5.0.15"
vault_chart_version="0.28.0"
external_secrets_chart_version="0.9.19"
keycloak_version="24.0.5"
trivy_chart_version="0.23.2"

hosts_gw="kubesol-dev4-c1"

[controller_one]
kubesol-dev4-c1    int_ip=10.135.187.238 controller_worker=true ansible_connection=local 
```

7. run `ansible-playbook 200-prep.yaml`. If all ok, continue, else debug and re-run the playbook

8. run `ansible-playbook 300-new-rke2.yaml`. This will take 2-3 minutes. If all ok, continue, else debug and re-run the playbook

9. you now have a Kubernetes cluster with one node. you could use it with:

```
$ kubectl get nodes

NAME              STATUS     ROLES                       AGE   VERSION
kubesol-dev4-c1   NotReady   control-plane,etcd,master   78s   v1.29.4+rke2r1
```

Wait until you see the node STATUS Ready.

10. For playbooks >400 we recommend running them one by one and checking status after each one. For example:

## Kubernetes dashboard

```
# cert-manager
ansible-playbook 430-cert-manager.yaml  # you will need this for ssl certificates
kubectl -n cert-manager get pods        # wait for all pods to be Ready

# kubernetes-dashboard
ansible-playbook 460-kubernetes-dashboard.yaml
ansible-playbook 462-kubernetes-dashboard-ingress.yaml 
kubectl -n kubernetes-dashboard get pods         # wait for all pods to be Ready
kubectl -n kubernetes-dashboard get ingress      # note the URL
kubectl -n kubernetes-dashboard get certificate  # SSL certificate is ready?

# get the access token and open the dashboard in browser
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={.data.token} | base64 -d ; echo
```

## Longhorn storage class

Before installing Longhorn storage class, edit `410-longhorn-prep.yaml` and change `hosts: worker` to `hosts: all`. Then:

```
# edit 410-longhorn-prep.yaml and change hosts: worker to hosts: all
ansible-playbook 410-longhorn-prep.yaml
ansible-playbook 411-longhorn-helm.yaml
ansible-playbook 412-longhorn-web.yaml 

kubectl -n longhorn-system get pods    # check all pods to be Ready
kubectl -n longhorn-system get ingress # get hostname
ansible-playbook 412-longhorn-web.yaml # run the playbook again to see the password
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



