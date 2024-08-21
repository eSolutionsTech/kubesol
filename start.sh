#!/bin/bash

echo 'Install some packages'
apt install ansible python3-kubernetes pwgen cowsay -y
ansible-galaxy collection install kubernetes.core

cd ansible || exit 1

[ -f ansible.cfg ] || cp ansible.cfg-example ansible.cfg
[ -f Inventory ]   || cp Inventory-multi-node-example Inventory

echo
echo '  Review and edit files ansible.cfg and Inventory'
echo '  When you are ready, run'
echo
echo '    cd ansible'
echo '    ansible-playbook 000-all.yaml'
echo

