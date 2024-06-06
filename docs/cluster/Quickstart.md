# Kubesol quickstart

A full production Kubesol setup will require at least 7 VMs (one gateway, 3 controller nodes, 3 worker nodes). But you may experiment on a single VM even with some limitations.

For this, create a Virtual Machine with Ubuntu Linux and at least 8GB RAM, 2-8 CPU cores, 50 GB disk.

A full step by step tutorial will be available soon, for now some quick notes:

Your Ansible Inventory file will look something like this:

```
[all:vars]
rke2_version="v1.29.4+rke2r1"

longhorn_device="sda"
directpv_device=""

project_name="kubesol_test" # used in nginx config
ext_dns_name="kubesol-test.example.com"
letsencrypt_email="some.email@example.com"

longhorn_version="1.6.1"
certmanager_version="v1.14.4"
argocd_chart_version="7.0.0"
minio_operator_chart_version="5.0.15"
vault_chart_version="0.28.0"
external_secrets_chart_version="0.9.19"
keycloak_version="24.0.5"
trivy_chart_version="0.23.2"

# you may choose to have an empty section [gateway]
# in which case the ansible playbooks won't try to configure that host
# but you still need to define the variable hosts_gw which is
# the internal name of the gw/nginx used in rke2 config 
hosts_gw="kubesol-test-c1"
[gateway]

[controller_one]
kubesol-test-c1.example.com  int_ip=10.135.187.236  controller_worker=true
```

Longhorn volumes will work even if they will remain in _Degraded_ state because there are not enough nodes for 3 replicas.


