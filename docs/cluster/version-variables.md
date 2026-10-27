# Version variables

When not defined, by default, the latest available version is used for Helm-chart components.
You can pin versions with variables in the `Inventory` file (or in playbooks).

## RKE2

`rke2_version` selects the Kubernetes / RKE2 release (for example `v1.37.1+rke2r1`).
It is especially useful for [cluster upgrade](upgrade-cluster.md).
See https://github.com/rancher/rke2/releases for valid tags.

## Helm charts

All other version variables are named `*_chart_version` — the Helm chart version for a component.
List them from the `ansible` directory with:

```
grep _chart_version *.yaml
```

Leave a variable unset (or commented out) to install the latest chart from that component’s Helm repo.

## Helm CLI

Playbook `290-c1.yaml` installs the Helm binary from a pinned archive (currently **Helm v3.22.1**, variable `HELM_ARCHIVE`).
That is independent of chart versions in Inventory.
