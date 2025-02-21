# Vertical Pod Autoscaler (VPA)
# and Goldilocks

VPA is a set of components that automatically adjust the amount of CPU and memory requested by pods running in the Kubernetes Cluster. But instead of automatically adjusting, it's very useful to just provide recommendations for CPU and memory requests / limits.

Official docs at https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler

Goldilocks (by Fairwinds) is an optional helper tool to automate the creation of VPA objects and also provide a web dashboard.

## Check

If it's not installed you can do it with:
```
ansible-playbook 540-vpa.yaml
ansible-playbook 542-goldilocks.yaml # optional
``` 

To check status:

```
kubectl -n vpa get pods
NAME                                        READY   STATUS      RESTARTS   AGE
vpa-admission-controller-8678b87646-6cqlr   1/1     Running     0          24h
vpa-recommender-585b9f8c54-ncn82            1/1     Running     0          24h

kubectl -n goldilocks get pods
NAME                                     READY   STATUS    RESTARTS   AGE
goldilocks-controller-7d86fdccd7-xt5lm   1/1     Running   0          24h
goldilocks-dashboard-6c5688877-hsnnf     1/1     Running   0          24h
goldilocks-dashboard-6c5688877-nsfxg     1/1     Running   0          24h
```

## Usage - goldilocks

With goldilocks you just label a namespace like this:
```
kubectl label ns <<SOME-NAMESPACE>>  goldilocks.fairwinds.com/enabled=true
```

After this, the VPA objects will be automatically created and you cand use `kubectl -n <<SOME-NAMESPACE>> get vpa` to check them.

## Goldilocks web dashboard

Use kubectl port-forward like this:

```
kubectl -n goldilocks port-forward svc/goldilocks-dashboard 8080:80
echo "Visit http://127.0.0.1:8080 to use your application"
```

## Usage - manual VPA

Please read the official VPA documentation. But for a quick start, create this object 
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

