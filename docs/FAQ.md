# Kubesol FAQ

**Why yet another Kubernetes distribution?**

This is the open-source world. Why there are so many Linux distributions? If you like it, use it. We are using it at our company.

**Why not using Ansible roles?**

One of our guiding principles is to keep this as simple and easy to understand possible, even for a junior Devops Engineer. 
Even though Ansible roles are good for modularity and hide complexity, they are not good at encouraging deep understanding of how things work.

**Why wouldn't I use the official RKE2 installer?**

By all means, do it. But in our Ansible playbooks we have included a lot of knowledge for solving some problems, 
results from repeating the official installation methods many times (and this is not only for RKE2 but for other components).

Also we think our documentation is very good for a quick start with many Kubernetes components.

**Why do you offer commercial support, isn't this totally free?**

Yes, it is totally free to use it. Only the support is commercial, like, for example in Ubuntu Linux.

