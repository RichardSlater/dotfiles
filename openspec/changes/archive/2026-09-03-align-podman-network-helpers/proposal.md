## Why

The Podman role builds Podman `v6.0.2` in `/usr/local` but installs Debian's Netavark and Aardvark-DNS `1.14.x` packages. Podman 6 invokes Netavark's `create` operation, which those helpers do not implement, causing rootless network creation and Compose to fail before containers start.

## What Changes

- Provision Netavark and Aardvark-DNS versions compatible with the pinned Podman 6 release from reviewed, immutable upstream artifacts.
- Verify downloaded helper artifacts with publisher SHA-256 digests before installing them into Podman's source-built helper location.
- Stop using distribution Netavark and Aardvark-DNS packages as the network-helper source for the source-built Podman installation.
- Validate the rootless network create/remove path independently of Compose.

## Capabilities

### New Capabilities
- `podman-network-helper-alignment`: Provision and verify network helpers that are compatible with the repository's pinned source-built Podman release.

### Modified Capabilities

- None.

## Impact

- Affects `scripts/ansible/roles/podman/`, its provisioning inputs, and role tests/documentation.
- Replaces the current mixed source-built Podman and distribution-helper installation boundary.
- Changes the rootless Podman network backend's helper binaries; existing user-local containers, images, networks, and volumes are not reset by this change.
