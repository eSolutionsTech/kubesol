
    ln -s ../ansible/* .
                              # "copy" ansible files in this directory

    ansible-playbook 000-all.yaml

# to use kubectl / helm commands:
    export KUBECONFIG=.kubeconfig
   
