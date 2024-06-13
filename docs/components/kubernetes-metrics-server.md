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
$ kubectl -n kubernetes-dashboard  top pods
NAME                                                    CPU(cores)   MEMORY(bytes)   
kubernetes-dashboard-api-5cd9f5b7-zz95t                 2m           17Mi            
kubernetes-dashboard-auth-856bf7d5df-gcxmm              1m           8Mi             
kubernetes-dashboard-kong-65476f87d4-fggqz              5m           128Mi           
kubernetes-dashboard-metrics-scraper-649fdcf444-r44nr   1m           21Mi            
kubernetes-dashboard-web-6f96cf865c-d7jsh               0m           9Mi    
```

