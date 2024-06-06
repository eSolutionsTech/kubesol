# Longhorn storage

Lonhorn is a Kubernetes storage system. Read more at https://github.com/longhorn/longhorn
and https://longhorn.io/docs/ .

## Longhorn web-interface

The URL is something like `https://longhorn.<<ext_dns_name>>`, 
you can get the exact address with `kubectl -n longhorn-system get ingress`.

Retrieve the admin password with:

```
ansible-playbook 412-longhorn-web.yaml
```

![](screenshot3.png "")

![](longhorn.png "")

