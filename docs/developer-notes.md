# Developer notes

## Ansible Playbook Techniques

### Storage and Device Management
- How to format and mount a block device (and only if a variable is defined): `250-mount-longhorn.yaml`
  ```yaml
  # Example snippet:
  - name: Format the device
    filesystem:
      fstype: ext4
      dev: "{{ longhorn_device }}"
    when: longhorn_device is defined
  ```

### User Interaction
- How to ask "are you sure you want to continue etc": `399-uninstall.yaml`
  ```yaml
  # Example snippet:
  - name: Confirm uninstallation
    pause:
      prompt: "Are you sure you want to uninstall RKE2 from all nodes? This will DELETE ALL YOUR DATA. Type 'yes' to continue"
    register: confirmation
    failed_when: confirmation.user_input != "yes"
  ```

### Host Selection and Delegation
- How to get the name of the first host from a group: `332-more-controllers.yaml`, `342-workers.yaml` at `delegate_to`
  ```yaml
  # Example snippet:
  - name: Copy kubeconfig from first controller
    delegate_to: "{{ groups['controllers'][0] }}"
    # Task details...
  ```

### Execution Control
- Run tasks one by one: `330-more-controllers.yaml` at `serial`
  ```yaml
  # Example snippet:
  - hosts: controllers[1:]
    serial: 1
    # Task details...
  ```

## Common Development Patterns

### Conditional Execution
- Using tags to selectively run parts of playbooks
- Using variables to enable/disable features

### Error Handling
- Using `ignore_errors` and `failed_when` for graceful failure handling
- Using `register` and checking results for conditional execution

### Security Best Practices
- Using `no_log: true` for sensitive information
- Managing secrets with Vault integration

## Troubleshooting

### Common Issues
- RKE2 installation failures: Check system requirements and network connectivity
- Certificate issues: Verify DNS resolution and firewall settings
- Storage problems: Check device permissions and filesystem status

### Debugging Techniques
- Using `ansible -vvv` for verbose output
- Checking logs on target hosts
- Using `kubectl describe` for detailed resource information

## Contributing Guidelines

### Code Style
- Follow consistent YAML formatting
- Use descriptive variable names
- Include comments for complex operations

### Testing
- Test playbooks in a development environment before submitting
- Verify idempotence (playbooks can be run multiple times without errors)
- Test with different OS versions when applicable

### Documentation
- Update relevant documentation when adding new features
- Include examples for new functionality
- Document any new variables or dependencies

