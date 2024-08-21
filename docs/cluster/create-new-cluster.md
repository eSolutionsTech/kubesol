# Create new cluster

## Pre-requisites

These requirements are the ideal case in which this system works.

### Virtual Machines (VMs)

For a quickstart with a single VM, see [this guide](Quickstart.md).

For this one, you will need a number of VMs. 
The tested operating systems are Ubuntu 22.04 and 24.04 on all VMs. 
SSH as root with key on those VMs (or as user with sudo without password).

Our minimal configuration is like this:

- _clusterName_-gw : This will run nginx as a reverse proxy. 2 GB RAM, 2 CPU cores, 20GB disk
- _clusterName_-c1 : This will be the first Kubernetes controller. 4 GB RAM, 2 CPU cores, 20GB disk
- _clusterName_-c2/3 : Secondary Kubernetes controllers. Optional but highly recommended. Same specs as `c1`.
- _clusterName_-w1 : First worker node. 8 GB RAM, 4 CPU cores, 50 GB root filesystem plus 2 additional disks at least 10 GB each for storage classes.
- _clusterName_-w2/3 : Additional worker nodes. Optional but highly recommended. Same specs as `w1`.

### Networking

All VMs should have the right hostname and private IP. A `etc-hosts` file can be generated and deployed based on `Inventory` if you define the variable `int_ip` for all VMs.

### External DNS

To access it from outside and use Letsencrypt SSL certificates you will need:

- The DNS name _ext_dns_name_ (defined in Ansible Inventory, see below) to point out to a public IP. This IP is to be redirected to the private IP of _clusterName_-gw
- Catch-all DNS name *._ext_dns_name_ to point out to the same public IP


## Run everything from c1

We are using the first controller (`c1`) as the Ansible run host. So, on the developer machine you will just need to ssh into that. 

As root on `c1` node, clone the git repo then run the `start.sh` script:

```
c1 # cd /root
c1 # git clone https://github.com/eSolutionsTech/kubesol.git
c1 # cd kubesol
c1 # ./start.sh
```

## Details on ansible Inventory file

In the `ansible` directory you must create a file called `Inventory`, see the example below.

This file contains hostnames and variables used by the project. Most of them are self explanatory. Variables `rke2_version` and the rest named `*_chart_version` can be commented out to install the latest version available. 

On controller_one host, the `ansible_connection=local` is important since we decided to run Ansible playbooks from this host.

A simple example is this:

```
[all:vars]

D="/root/.kubesol"

#rke2_version="v1.27.12+rke2r1"

longhorn_device="sdb"
directpv_device="sdc"

project_name="kubesol_dev2" # used in nginx config
ext_dns_name="dev2.kubesol.com"
letsencrypt_email="root@kubesol.com"

#longhorn_chart_version="1.6.1"
#certmanager_chart_version="v1.14.4"
#argocd_chart_version="7.0.0"
#minio_operator_chart_version="5.0.15"

# you may choose to have an empty section [gateway]
# in which case the ansible playbooks won't try to configure that host
# but you still need to define the variable hosts_gw which is
# the internal name/IP used in rke2 config 
hosts_gw="kubesol-dev2-gw"
[gateway]
kubesol-dev2-gw int_ip=192.168.40.96

# the first controller node
[controller_one]
kubesol-dev2-c1 int_ip=192.168.40.85 ansible_connection=local

# second and third controller nodes
[controller]
kubesol-dev2-c2 int_ip=192.168.40.86
kubesol-dev2-c3 int_ip=192.168.40.87

# worker nodes
[worker]
kubesol-dev2-w1 int_ip=192.168.40.88
kubesol-dev2-w2 int_ip=192.168.40.89
kubesol-dev2-w3 int_ip=192.168.40.90
```


