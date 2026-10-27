#!/bin/bash

echo 'Install some packages'
apt install ansible python3-kubernetes pwgen cowsay -y
ansible-galaxy collection install kubernetes.core

cd ansible || exit 1

[ -f ansible.cfg ] || cp ansible.cfg-example ansible.cfg
# Single-node Inventory by default (quickstart). For multi-node, copy Inventory-multi-node-example instead.
[ -f Inventory ]   || cp Inventory-single-node-example Inventory

echo
echo '  Review and edit files ansible.cfg and Inventory'
echo '  For a multi-node cluster: cp Inventory-multi-node-example Inventory'
echo '  When you are ready, run'
echo
echo '    cd ansible'
echo '    ansible-playbook 000-all.yaml'
echo

