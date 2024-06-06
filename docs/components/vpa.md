# Vertical Pod Autoscaler (VPA)

VPA is a set of components that automatically adjust the amount of CPU and memory requested by pods running in the Kubernetes Cluster. But instead of automatically adjusting, it's very useful to just provide recommendations for CPU and memory requests / limits.

Official docs at https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler

## Check

If it's not installed you can do it with `ansible-playbook 540-vpa.yaml` and check it's status with:

```
$ kubectl -n kube-system get pods | grep vpa
vpa-admission-controller-68cdcbd76d-k72ws               1/1     Running   0              45s
vpa-recommender-59d5bd5b6c-gkrzx                        1/1     Running   0              52s
vpa-updater-5494f59c88-snsz7                            1/1     Running   0              53s
```

## Usage

Please read the official documentation. But for a quick start, create this object 
inside our examples namespace:

```
apiVersion: "autoscaling.k8s.io/v1"
kind: VerticalPodAutoscaler
metadata:
  name: dummy-vpa
  namespace: dummy
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: StatefulSet
    name: dummy
  updatePolicy:
    updateMode: "Off"
```

then check `kubectl -n dummy describe vpa`.

