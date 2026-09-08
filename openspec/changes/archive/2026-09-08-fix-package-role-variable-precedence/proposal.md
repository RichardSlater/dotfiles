## Why

The package role defines `packages` in role vars, whose higher Ansible precedence silently overrides the inventory list. Consequently, locally applied provisioning omits declared tools such as ShellCheck.

## What Changes

- Remove the role-level `packages` override so inventory package selections are effective.
- Preserve the package role's empty defaults for callers that do not supply a package list.
- Verify that ShellCheck is included in the effective Debian package list.

## Capabilities

### New Capabilities
- `inventory-package-provisioning`: Ensure declared inventory packages are installed by the package role.

### Modified Capabilities

- None.

## Impact

- `scripts/ansible/roles/packages/vars/main.yml`
- `scripts/ansible/group_vars/all.yml`
- Local developer-tool provisioning through the Ansible playbook
