# Kubernetes metrics-server

Metrics Server is a resource metrics for Kubernetes used for autoscaling (HPA/VPA). Official docs at https://github.com/kubernetes-sigs/metrics-server

## Usage

It is installed by default. You can use it in command line with `kubectl top`:

```
# check resources usage on nodes
$  kubectl top nodes
NAME              CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
kubesol-dev2-c1   429m         21%    3064Mi          78%       
kubesol-dev2-c2   530m         26%    2970Mi          75%       
kubesol-dev2-c3   463m         23%    2866Mi          73%       
kubesol-dev2-w1   640m         16%    4242Mi          53%       
kubesol-dev2-w2   1248m        31%    4794Mi          60%       
kubesol-dev2-w3   720m         18%    4391Mi          55%       

# check resource usage in a namespace
$ kubectl -n longhorn-system top pods
NAME                                                CPU(cores)   MEMORY(bytes)   
csi-attacher-5dcc766457-abc12                       1m           12Mi            
longhorn-manager-xyz12                              15m          128Mi           
```


