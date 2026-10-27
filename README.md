# Kubesol

_Kubesol_ is a [free and open-source](LICENSE.md) Kubernetes distribution
with optional commercial support and / or license by [esolutions.tech](https://www.esolutions.tech/kubesol).

## Here are the main advantages that make our product a standout choice:
- **Free and Open-Source, just as our MOTTO** Enjoy the benefits of a cost-effective solution with the option for premium commercial support if needed.
- **Streamlined Installation**: Simplify your setup with a repeatable installation and configuration process, all driven by efficient Ansible playbooks.
- **Seamless Kubernetes Management**: Easily create and upgrade Kubernetes clusters with the reliable [RKE2](https://github.com/rancher/rke2) system.
- **Pre-Configured Storage Classes**: Local-path is enabled by default; [Longhorn](docs/components/longhorn.md) and [DirectPV](docs/components/directpv.md) are optional (uncomment in `ansible/400-setup-k8s.yaml`; DirectPV needs extra disks on workers). See [Storage classes](docs/components/Storage-classes.md).
- **Comprehensive Kubernetes Components**: A small core set is enabled by default; others are optional playbooks you can uncomment or run separately. See the [full list](docs/README.md#components).
- **Extensive Documentation**: Access detailed documentation and example usage guides for a wide range of components, ensuring you have all the support you need.
- **User-Friendly**: Operate with ease, requiring only minimal knowledge of Ansible, kubectl, and Helm, making it accessible even for DevOps professionals with limited experience.

The detailed documentation is [here](docs/README.md).

See also [AGENTS.md](AGENTS.md) (Cursor / AI-assisted improvements since October 2026).
