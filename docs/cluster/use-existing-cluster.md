# To use an existing cluster

The simplest way is to SSH to where you ran the Ansible playbooks, usually the `controller_one` VM.
There, `/root/.kube/config` is set up and you can use `kubectl` and `helm` directly.

If you want to run from your laptop, use `ansible-playbook 320-get-kubeconfig.yaml`
and copy the generated `.kubeconfig` file to your machine (for example with `scp`).
