# External Secrets Operator (ESO)

__External Secrets Operator__ is a Kubernetes operator that reads information from external sources (like Vault and others) 
and automatically injects the values into Kubernetes secrets. Read more at https://github.com/external-secrets/external-secrets
 and https://external-secrets.io/latest/ .

## Install

If it's not installed, use `ansible-playbook 560-external-secrets.yaml`. Afterwards, you should see something like this:

```
$ kubectl -n external-secrets get pods
NAME                                                READY   STATUS    RESTARTS   AGE
external-secrets-67896f7d9f-xq794                   1/1     Running   0          58s
external-secrets-cert-controller-6c88c56c69-djx2s   1/1     Running   0          58s
external-secrets-webhook-5f79b565bb-lpz4d           1/1     Running   0          58s

$ kubectl get crds | grep externalsecret
clusterexternalsecrets.external-secrets.io              2024-06-05T06:23:34Z
externalsecrets.external-secrets.io                     2024-06-05T06:23:35Z

```

## Usage

This is useful in conjunction with ArgoCD and Vault. 

Two kind of important objects (for more see `kubectl api-resources | grep external-secrets`):

  - SecretStore (or ClusterSecretStore) - where you define the secret provider and how to access it
  - ExternalSecret (or ClusterExternalSecret) - where you define a reference to SecretStore and the target secret to be created

Read the official docs for more.

