# Trivy security scanner

Trivy is a security scanner and it can be run inside a Kubernetes cluster. See https://github.com/aquasecurity/trivy-operator

## Install

Trivy is **optional** (commented out in `400-setup-k8s.yaml`).

To check it after install:

```
$ kubectl -n trivy-system  get pods
NAME                                        READY   STATUS      RESTARTS   AGE
[...]
trivy-trivy-operator-687dbbfd97-m8phd       1/1     Running     0          2m25s
```

To install it: `ansible-playbook 510-trivy.yaml`

Trivy’s Helm values omit `storageClassName` so PVCs use the cluster default. Uncomment `storageClassName: longhorn` in `files/trivy/values-trivy.yaml` if you want Trivy on Longhorn.

Optional Grafana dashboard ConfigMap (after monitoring/Grafana is up):

```
ansible-playbook 511-trivy-grafana-dash.yaml
```

## Usage

A quick example:

```
$ kubectl get clustervulnerabilityreports
[...]

# vulnerabilityreports is a namespaced resource. use it with -A or -n namespace
$ kubectl get vulnerabilityreports -A
[...]

# vulnerabilityreports is a namespaced resource. use it with -n namespace
$ kubectl describe vulnerabilityreports pod-pg-directpv-1-postgres 
[...]
```

## Grafana dashboard

You can import predefined Trivy dashboards. Example: https://grafana.com/grafana/dashboards/16337-trivy-operator-vulnerabilities/

