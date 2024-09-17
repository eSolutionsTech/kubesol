# Adding more worker nodes

In a production cluster you will have 3 controller nodes but you can have many worker nodes.
To add one or more worker nodes after the initial setup, you can simply

- on node `c1` where ansible files are, add one or more nodes to the `Inventory` file
- run `ansible-playbook 340-workers.yaml`. If you wish to speed this up you can even use `--limit new-worker-name`
to run it only on the newly added node.

