# Vault and ExternalSecrets

Vault is a system for securely storing secrets. It can be run in Kubernetes and it has a web-interface.

ExternalSecrets is an operator for accessing those secrets from Kubernetes.

## Vault init

Vault is installed but needs to be initialized (pods are Ready 0/1):

```
$ kubectl -n vault get  pods
NAME      READY   STATUS    RESTARTS   AGE
vault-0   0/1     Running   0          10m
vault-1   0/1     Running   0          10m
vault-2   0/1     Running   0          10m

$ kubectl -n vault exec -it vault-0 -- vault operator init
Unseal Key 1: 4VBQCgy+ON[...]
Unseal Key 2: l0rM/T6wwe[...]
Unseal Key 3: nxJ9GgJc6H[...]
Unseal Key 4: 4sfjvgQ21S[...]
Unseal Key 5: aFKauRrzYp[...]

Initial Root Token: hvs.rVBCi[...]
[...]
Vault initialized with 5 key shares and a key threshold of 3.
```

**Save those keys, you will never see them.** You will need 3 out of those 5 keys to unseal the vault.

## Vault raft joining

To add the second and third nodes and create a Vault cluster, run:

```
$ kubectl -n vault exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
Key       Value
---       -----
Joined    true

$ kubectl -n vault exec -ti vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
Key       Value
---       -----
Joined    true
```

## Vault unseal

Run this command 3 times, each time give it a different key:

```
$ kubectl -n vault exec -it vault-0 -- vault operator unseal 
Unseal Key (will be hidden): _
```

On the third run you will see the answer:
```
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
```

Do the same for other pods, unseal three times:
```
kubectl -n vault exec -it vault-1 -- vault operator unseal 
[...

kubectl -n vault exec -it vault-2 -- vault operator unseal 
[...]
```

## Verify Vault status

Use the above __Initial Root Token__ and run: 

```
$ kubectl -n vault exec -it vault-0 -- vault login 
Token (will be hidden): _
[...]

$ kubectl -n vault exec -ti vault-0 -- vault operator raft list-peers
Node                                    Address                        State       Voter
----                                    -------                        -----       -----
2eb937f6-8bb0-e1b9-0bbc-df72a36b702f    vault-0.vault-internal:8201    leader      true
436cdc73-834f-0bd7-13b0-a48426a08fe1    vault-1.vault-internal:8201    follower    true
c113ee9d-2ed9-eac4-28e0-efcc82ee31c1    vault-2.vault-internal:8201    follower    true
```

## Access web interface

Use `kubectl -n vault get ingress` to get the hostname and access it in browser using the above __Initial Root Token__.




