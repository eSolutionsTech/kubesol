# Strimzi operator for Kafka

Strimzi is an operator for creating Kafka resources in Kubernetes. See https://strimzi.io/documentation/ for details.

## Install

To check it: 

```
$ kubectl -n strimzi get pods
NAME                                       READY   STATUS    RESTARTS   AGE
strimzi-cluster-operator-74fc686c7-rn2f6   1/1     Running   0          24m
```

To install it: `ansible-playbook 520-strimzi.yaml`.

## Usage

To create a simple Kafka cluster and test operator functionality use:

```
  kubectl apply -f files/strimzi/kafka-demo-ns.yaml,files/strimzi/kafka-demo.yaml 
  [...]

# wait for kafka cluster to came up
  kubectl -n kafka-demo get kafka
NAME         DESIRED KAFKA REPLICAS   DESIRED ZK REPLICAS   READY   METADATA STATE   WARNINGS
kafka-demo   3                        3                     True    ZooKeeper        True

  kubectl -n kafka-demo get pods
NAME                                          READY   STATUS    RESTARTS   AGE
kafka-demo-entity-operator-858bfbbf4c-pdfsk   2/2     Running   0          98s
kafka-demo-kafka-0                            1/1     Running   0          2m22s
kafka-demo-kafka-1                            1/1     Running   0          2m22s
kafka-demo-kafka-2                            1/1     Running   0          2m22s
kafka-demo-zookeeper-0                        1/1     Running   0          3m32s
kafka-demo-zookeeper-1                        1/1     Running   0          3m32s
kafka-demo-zookeeper-2                        1/1     Running   0          3m32s
```

Note that we are using directpv-min-io storage class for Kafka! For more advanced examples, consult the official Strimzi documentation.

### To cleanup the above demo:

```
  kubectl delete -f files/strimzi/kafka-demo.yaml

  # the PVC are NOT DELETED automatically!!!
  kubectl -n kafka-demo get pvc
  [...]

  # delete PVC from namespace
  kubectl -n kafka-demo get pvc -o name | while read p ; do kubectl -n kafka-demo delete $p ; done 

  kubectl delete namespace kafka-demo
```

