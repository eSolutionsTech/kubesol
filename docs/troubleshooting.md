# Kubesol Troubleshooting Guide

This guide provides solutions for common issues you might encounter when deploying and managing Kubesol clusters.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Cluster Operations](#cluster-operations)
- [Networking Issues](#networking-issues)
- [Storage Issues](#storage-issues)
- [Component-Specific Issues](#component-specific-issues)
- [Performance Issues](#performance-issues)
- [Debugging Tools](#debugging-tools)

## Installation Issues

### RKE2 Installation Failures

**Symptoms:**
- Ansible playbook fails during RKE2 installation
- Node doesn't join the cluster

**Possible Causes and Solutions:**

1. **System Requirements Not Met**
   - Ensure nodes meet minimum requirements (CPU, RAM, disk space)
   - Check with: `free -m`, `df -h`, `nproc`

2. **Network Connectivity Issues**
   - Verify nodes can reach each other and the internet
   - Check with: `ping`, `curl`, `traceroute`
   - Ensure required ports are open: `sudo ufw status` or `sudo iptables -L`

3. **Package Repository Issues**
   - Verify package repositories are accessible
   - Try: `sudo apt update` or equivalent for your OS

4. **Conflicting Software**
   - Check for other container runtimes or Kubernetes installations
   - Remove with: `sudo apt remove docker kubelet kubeadm kubectl` (adjust for your environment)

### Ansible Playbook Failures

**Symptoms:**
- Ansible playbook fails with error messages
- Tasks timeout or hang

**Possible Causes and Solutions:**

1. **SSH Connectivity Issues**
   - Verify SSH access to all nodes
   - Check with: `ssh user@node`
   - Ensure SSH keys are properly configured

2. **Privilege Escalation Issues**
   - Ensure the Ansible user has sudo privileges
   - Check sudoers configuration: `sudo visudo`

3. **Variable Configuration Issues**
   - Verify inventory variables are correctly set
   - Check for typos or missing required variables

## Cluster Operations

### Node Not Ready

**Symptoms:**
- Node shows as "NotReady" in `kubectl get nodes`
- Pods scheduled to the node are stuck in "Pending" state

**Possible Causes and Solutions:**

1. **Kubelet Service Issues**
   - Check kubelet status: `sudo systemctl status rke2-agent` or `sudo systemctl status rke2-server`
   - View logs: `sudo journalctl -u rke2-agent` or `sudo journalctl -u rke2-server`

2. **Network Plugin Issues**
   - Check CNI plugin pods: `kubectl -n kube-system get pods | grep -i cni`
   - View CNI logs: `kubectl -n kube-system logs <cni-pod-name>`

3. **Resource Constraints**
   - Check node resources: `kubectl describe node <node-name>`
   - Look for resource pressure conditions

### Pod Scheduling Issues

**Symptoms:**
- Pods stuck in "Pending" state
- Pods frequently restarting

**Possible Causes and Solutions:**

1. **Resource Constraints**
   - Check if the node has enough resources: `kubectl describe node <node-name>`
   - Adjust pod resource requests and limits

2. **Node Affinity/Taints**
   - Check for node taints: `kubectl describe node <node-name> | grep Taints`
   - Ensure pod tolerations match node taints

3. **PersistentVolume Issues**
   - Check PV/PVC status: `kubectl get pv,pvc`
   - Ensure storage classes are available: `kubectl get sc`

## Networking Issues

### Service Connectivity Issues

**Symptoms:**
- Services cannot be reached
- DNS resolution fails

**Possible Causes and Solutions:**

1. **CoreDNS Issues**
   - Check CoreDNS pods: `kubectl -n kube-system get pods | grep coredns`
   - View CoreDNS logs: `kubectl -n kube-system logs <coredns-pod-name>`

2. **Service Configuration**
   - Verify service endpoints: `kubectl get endpoints <service-name>`
   - Check service selectors match pod labels

3. **Network Policy Issues**
   - Check for restrictive network policies: `kubectl get networkpolicies --all-namespaces`
   - Temporarily disable network policies to test

### Ingress Issues

**Symptoms:**
- Ingress resources don't route traffic
- SSL/TLS errors

**Possible Causes and Solutions:**

1. **Ingress Controller Issues**
   - Check ingress controller pods: `kubectl -n kube-system get pods | grep ingress`
   - View ingress controller logs: `kubectl -n kube-system logs <ingress-pod-name>`

2. **Certificate Issues**
   - Verify certificate status: `kubectl get certificates,certificaterequests,orders,challenges --all-namespaces`
   - Check cert-manager logs: `kubectl -n cert-manager logs -l app=cert-manager`

3. **DNS Configuration**
   - Ensure DNS records point to the correct ingress IP
   - Test with: `nslookup <hostname>` or `dig <hostname>`

## Storage Issues

### Longhorn Issues

**Symptoms:**
- PVCs stuck in "Pending" state
- Volumes degraded or faulted

**Possible Causes and Solutions:**

1. **Node Disk Issues**
   - Check node disk space: `df -h`
   - Verify Longhorn node status in the Longhorn UI

2. **Replica Count Issues**
   - Check volume replica count in Longhorn UI
   - Ensure enough nodes are available for the desired replica count

3. **Filesystem Issues**
   - Check for filesystem errors: `sudo dmesg | grep -i error`
   - Run filesystem checks: `sudo fsck -y /dev/<device>`

For more Longhorn troubleshooting, see: [Longhorn Troubleshooting](https://longhorn.io/kb/troubleshooting-volume-with-multipath/)

### DirectPV Issues

**Symptoms:**
- DirectPV drives not showing up
- PVCs using DirectPV stuck in "Pending"

**Possible Causes and Solutions:**

1. **Drive Discovery Issues**
   - Check drive status: `kubectl -n directpv-io get directpvdrives`
   - Manually discover drives: `kubectl -n directpv-io directpv discover --drives /dev/sd*`

2. **Drive Initialization Issues**
   - Check for drive initialization errors: `kubectl -n directpv-io logs -l app=directpv-controller`
   - Manually initialize drives: `kubectl -n directpv-io directpv init --drives <drive-id>`

## Component-Specific Issues

### Cert-Manager Issues

**Symptoms:**
- Certificates not being issued
- Certificate issuance errors

**Possible Causes and Solutions:**

1. **Issuer Configuration**
   - Check issuer status: `kubectl get issuers,clusterissuers`
   - Verify issuer configuration is correct

2. **ACME Challenges**
   - Check challenge status: `kubectl get challenges --all-namespaces`
   - Ensure DNS or HTTP challenges can complete

3. **Rate Limiting**
   - Check for Let's Encrypt rate limiting
   - Use staging environment for testing

For more cert-manager troubleshooting, see: [Cert-Manager Troubleshooting](https://cert-manager.io/docs/troubleshooting/)

### Monitoring Stack Issues

**Symptoms:**
- Prometheus alerts not firing
- Grafana dashboards not showing data

**Possible Causes and Solutions:**

1. **Prometheus Issues**
   - Check Prometheus pods: `kubectl -n monitoring get pods | grep prometheus`
   - View Prometheus logs: `kubectl -n monitoring logs <prometheus-pod-name>`

2. **Alertmanager Issues**
   - Check Alertmanager configuration: `kubectl -n monitoring get secret alertmanager-kube-prometheus-stack-alertmanager -o jsonpath='{.data.alertmanager\.yaml}' | base64 -d`
   - Verify alert routing is correct

3. **Grafana Issues**
   - Check Grafana datasources: `kubectl -n monitoring get secret grafana -o jsonpath='{.data.datasources\.yaml}' | base64 -d`
   - Verify Grafana can reach Prometheus

## Performance Issues

### Node Performance

**Symptoms:**
- High CPU/memory usage
- Slow response times

**Possible Causes and Solutions:**

1. **Resource Contention**
   - Check node resource usage: `kubectl top nodes`
   - Identify resource-intensive pods: `kubectl top pods --all-namespaces`

2. **Disk I/O Issues**
   - Check disk I/O: `iostat -x 1`
   - Consider using faster storage

3. **Network Saturation**
   - Check network usage: `iftop` or `nethogs`
   - Consider network optimizations

### Etcd Performance

**Symptoms:**
- Slow API server responses
- Etcd high latency alerts

**Possible Causes and Solutions:**

1. **Database Size Issues**
   - Check etcd database size: `ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt --cert=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt --key=/var/lib/rancher/rke2/server/tls/etcd/server-client.key endpoint status --write-out=table`
   - Consider defragmentation or compaction

2. **Disk Performance**
   - Ensure etcd is on SSD storage
   - Check disk latency: `iostat -x 1`

## Debugging Tools

### Kubernetes Debugging

- **kubectl describe**: `kubectl describe <resource-type> <resource-name>`
- **kubectl logs**: `kubectl logs <pod-name> [-c <container-name>]`
- **kubectl exec**: `kubectl exec -it <pod-name> -- <command>`
- **kubectl get events**: `kubectl get events --sort-by='.lastTimestamp'`

### System Debugging

- **journalctl**: `journalctl -u rke2-server -f`
- **dmesg**: `dmesg | tail`
- **top/htop**: `htop`
- **iotop**: `iotop`

### Network Debugging

- **tcpdump**: `tcpdump -i <interface> port <port>`
- **netstat**: `netstat -tulpn`
- **curl**: `curl -v <url>`

## Getting Help

If you're unable to resolve an issue using this guide, consider:

1. Checking the [Kubesol FAQ](FAQ.md)
2. Reviewing component-specific documentation
3. Contacting commercial support if you have a support contract
4. Opening an issue on the project repository

Remember to include:
- Detailed description of the issue
- Steps to reproduce
- Relevant logs and error messages
- Environment details (OS, Kubernetes version, etc.) 