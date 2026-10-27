# To reset an existing cluster

This removes an existing cluster and cleans up the virtual machines:

```
ansible-playbook 449-Uninstall-directpv.yaml   # if DirectPV was installed
ansible-playbook 399-uninstall.yaml
```

## Uninstall individual optional stacks

Without wiping the whole cluster, you can remove some components with dedicated playbooks:

```
ansible-playbook 498-uninstall-loki.yaml
ansible-playbook 499-uninstall-kube-prometheus-stack.yaml
```

(Other components are usually removed with `helm uninstall` in their namespace, or by reversing their install playbook.)
