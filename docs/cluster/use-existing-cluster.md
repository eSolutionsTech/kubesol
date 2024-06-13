# To use an existing cluster

The simplest way is to ssh where you ran the Ansible playbooks, usually the controller_one VM. 
In there, the file `/root/.kube/config' is setup and you can just use kubectl and helm commands. 

If you want to run from your laptop, use `ansible-playbook 320-get-kubeconfig.yaml` 
and scp the generated `.kubeconfig file to your machine.

