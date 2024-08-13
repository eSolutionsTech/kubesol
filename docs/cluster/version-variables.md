# Version variables

When not defined, by default, the latest available version is used for components. 
But you can set a specific version by using variables defined in `Inventory` file or in playbooks.

A special one is `rke2_version` which is very useful for [cluster upgrade](upgrade-cluster.md).

All other version variables are named `*_chart_version` and 
this is the version of the helm chart used for a component. 
You can see all those variables and in which playbooks are used by running in the ansible directory
`grep _chart_version *.yaml`. 


