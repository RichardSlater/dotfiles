## Why

The workstation playbook currently provisions language runtimes and CLI tools through independent roles, which makes their version management and activation inconsistent. Adding mise provides one declarative, user-local toolchain manager that can coordinate supported development runtimes across machines.

## What Changes

- Add an Ansible role that installs mise for the target user from a verified upstream release.
- Configure mise so its executable and managed tool shims are available in supported interactive shells.
- Add the role to the user-level provisioning sequence and document its configuration and validation path.
- Preserve existing runtime roles and their privilege boundaries; this change introduces mise as the common toolchain-management foundation rather than removing existing tools.

## Capabilities

### New Capabilities
- `mise-toolchain-provisioning`: Provision and configure mise as a user-local, reproducible toolchain manager through the Ansible playbook.

### Modified Capabilities

- None.

## Impact

- Affects `scripts/ansible/playbook.yml`, a new `scripts/ansible/roles/mise/` role, shared role variables, and Ansible documentation.
- Adds a direct mise release artifact as a provisioning input, requiring a pinned version, immutable source reference, and checksum documentation in `docs/PROVISIONING_INPUTS.md`.
- Affects user shell initialization so mise-managed tools are available after provisioning.
