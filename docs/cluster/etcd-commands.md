# Etcd commands

Useful commands for etcd debugging.

based on https://gist.github.com/superseb/3b78f47989e0dbc1295486c186e944bf

```
# etcd member list
root@kubesol-dev-c1:~# kubectl -n kube-system exec etcd-kubesol-dev-c1 -- sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl member list -w table"
+------------------+---------+-------------------------+-----------------------------+-----------------------------+------------+
|        ID        | STATUS  |          NAME           |         PEER ADDRS          |        CLIENT ADDRS         | IS LEARNER |
+------------------+---------+-------------------------+-----------------------------+-----------------------------+------------+
|  615ea235a52fd87 | started | kubesol-dev-c2-6c6b6515 |  https://64.226.110.22:2380 |  https://64.226.110.22:2379 |      false |
| 5b45c5141a23a96d | started | kubesol-dev-c3-48142814 | https://157.230.22.165:2380 | https://157.230.22.165:2379 |      false |
| 97e1945a9dcbbcc1 | started | kubesol-dev-c1-7181731b |   https://167.71.44.60:2380 |   https://167.71.44.60:2379 |      false |
+------------------+---------+-------------------------+-----------------------------+-----------------------------+------------+


# etcd endpoint status
root@kubesol-dev-c1:~# for etcdpod in $(kubectl -n kube-system get pod -l component=etcd --no-headers -o custom-columns=NAME:.metadata.name); do echo $etcdpod ; kubectl -n kube-system exec $etcdpod -- sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl endpoint status -w table"; done
etcd-kubesol-dev-c1
+------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|        ENDPOINT        |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| https://127.0.0.1:2379 | 97e1945a9dcbbcc1 |   3.5.9 |   24 MB |      true |      false |         2 |     112985 |             112985 |        |
+------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
etcd-kubesol-dev-c2
+------------------------+-----------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|        ENDPOINT        |       ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+------------------------+-----------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| https://127.0.0.1:2379 | 615ea235a52fd87 |   3.5.9 |   23 MB |     false |      false |         2 |     112988 |             112988 |        |
+------------------------+-----------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
etcd-kubesol-dev-c3
+------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|        ENDPOINT        |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| https://127.0.0.1:2379 | 5b45c5141a23a96d |   3.5.9 |   22 MB |     false |      false |         2 |     112991 |             112991 |        |
+------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+


# etcdctl endpoint health 
root@kubesol-dev-c1:~# for etcdpod in $(kubectl -n kube-system get pod -l component=etcd --no-headers -o custom-columns=NAME:.metadata.name); do echo $etcdpod ; kubectl -n kube-system exec $etcdpod -- sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl endpoint health -w table"; done
etcd-kubesol-dev-c1
+------------------------+--------+-------------+-------+
|        ENDPOINT        | HEALTH |    TOOK     | ERROR |
+------------------------+--------+-------------+-------+
| https://127.0.0.1:2379 |   true | 10.806627ms |       |
+------------------------+--------+-------------+-------+
etcd-kubesol-dev-c2
+------------------------+--------+-------------+-------+
|        ENDPOINT        | HEALTH |    TOOK     | ERROR |
+------------------------+--------+-------------+-------+
| https://127.0.0.1:2379 |   true | 11.569889ms |       |
+------------------------+--------+-------------+-------+
etcd-kubesol-dev-c3
+------------------------+--------+-----------+-------+
|        ENDPOINT        | HEALTH |   TOOK    | ERROR |
+------------------------+--------+-----------+-------+
| https://127.0.0.1:2379 |   true | 9.28691ms |       |
+------------------------+--------+-----------+-------+

```

