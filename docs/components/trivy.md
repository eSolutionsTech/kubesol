# Trivy security scanner

Trivy is a security scanner and it can be run inside a Kubernetes cluster. See https://github.com/aquasecurity/trivy

## Check

If it's not installed you can do it with `ansible-playbook 510-trivy.yaml` and check it's status with:


```
$ helm -n trivy-system ls
NAME 	NAMESPACE   	REVISION	UPDATED                              	STATUS  	CHART                	APP VERSION
trivy	trivy-system	3       	2024-06-01 10:49:01.452245 +0300 EEST	deployed	trivy-operator-0.23.1	0.21.1   

$ kubectl -n trivy-system  get pods
NAME                                        READY   STATUS      RESTARTS   AGE
[...]
trivy-trivy-operator-687dbbfd97-m8phd       1/1     Running     0          2m25s


# values set at files/trivy/values-trivy.yaml
$ helm -n trivy-system get values trivy
[...]
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

TBD

