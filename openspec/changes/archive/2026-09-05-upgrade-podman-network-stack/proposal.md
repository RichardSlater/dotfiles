## Why

The current Podman 6.0.2 role installs the matching Netavark and Aardvark-DNS 2.0.0 helpers. The reviewed upstream configuration has moved to Podman 6.1.1 and the compatible 2.1.0 helper pair, with explicit rootless storage configuration; this repository should adopt that supported stack while retaining its integrity and rollback protections.

## What Changes

- Upgrade the source-built Podman release from v6.0.2 to v6.1.1.
- Upgrade verified x86_64 Netavark and Aardvark-DNS artifacts from 2.0.0 to 2.1.0 with their matching SHA-256 checksums.
- Configure rootless overlay storage explicitly under the managed user's home directory and runtime directory.
- Update role documentation, static safeguards, and validation to cover the upgraded compatible stack.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `podman-network-helper-alignment`: Provision and validate the reviewed Podman 6.1.1 network-helper stack for rootless use.
- `reproducible-provisioning-inputs`: Maintain immutable version and checksum verification for the upgraded Podman and helper artifacts.

## Impact

- `scripts/ansible/roles/podman/{defaults,tasks,README}.yml`
- `scripts/ansible/tests/validate_podman_network_helpers.py`
- Podman role documentation and provisioning inventories
- Rootless Podman users receive a managed `~/.config/containers/storage.conf`
