# Minio

MinIO is a S3 compatible object store. See more at https://min.io and https://min.io/docs/minio/kubernetes/upstream/

## Usage

Minio operator is installed in namespace `minio-operator` 
(if not, run `ansible-playbook 530-minio-operator.yaml`) but you must create
__tenants__ and __buckets__. 

## Web interface

To access the **minio console**:

```
# get the hostname
kubectl -n minio-operator get ingress

# get JWT token
kubectl -n minio-operator  get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode ; echo 
```

and access in browser `https://minio...`.

## To create and play with a minimal tenant and bucket

See screenshots for our recommendations on your first tenant. Please note if you have less than 4 nodes, when create the tenant, change **"Pod Placement"**!

![](minio1.png "")

![](minio2.png "")


