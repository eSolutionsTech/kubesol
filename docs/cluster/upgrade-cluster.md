# Upgrade cluster

To upgrade an existing Kubernetes cluster you will just need to bump up the version (or create it) 
in `Inventory` file - variable `rke2_version` and run again 
`ansible-playbook 300-rke2-cluster.yaml`. 
You can see the available options by checking this page: https://github.com/rancher/rke2/releases

Do not try to skip more than one major version at a time, for example this was tested upgrading from Kubernetes 1.26 to 1.27. The exact value for the variable name from the releases page: https://github.com/rancher/rke2/releases (for example `v1.30.0+rke2r1` etc).

You may need to download a new version for the `rke2.sh` script, first delete it from VMs with:

```
  ansible all -m shell -a 'rm rke2.sh'
```

Also note compatibility for objects inside Kubernetes is in your responsability. 
You may use tools like https://github.com/doitintl/kube-no-trouble to help you.

