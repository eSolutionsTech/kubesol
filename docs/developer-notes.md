
# Developer notes

- how to include ansible playbooks: 000-all.yaml
- how to deploy a file from local to all nodes: 240-etc-hosts-copy.yaml 
- how to format and mount a block device (and only if a variable is defined): 250-mount-longhorn.yaml 
- how to run a series of tasks only when condition (include_tasks): 310-controller-one.yaml 330-more-controllers.yaml 340-workers.yaml
- how to get a remote file, store and modify it locally (.kubeconfig): 320-get-kubeconfig.yaml
- how to run a helm install (using .kubeconfig): 410-longhorn.yaml 
- how to run a kubectl apply from url (using .kubeconfig): 430-cert-manager.yaml
- how to ask "are you sure you want to continue etc": 399-uninstall.yaml
- how to get the name of the first host from a group: 332-more-controllers.yaml 342-workers.yaml  at `delegate_to`
- run one by one: 330-more-controllers.yaml at `serial` 

