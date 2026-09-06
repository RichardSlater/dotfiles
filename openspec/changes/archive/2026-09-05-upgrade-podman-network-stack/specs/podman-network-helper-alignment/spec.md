## MODIFIED Requirements

### Requirement: Reviewed Podman network-helper compatibility set
The Podman provisioning role SHALL define an exact reviewed compatibility set containing source-built Podman v6.1.1 and matching exact Netavark and Aardvark-DNS v2.1.0 versions. The configured Netavark and Aardvark-DNS versions SHALL have matching major-minor versions and SHALL be compatible with the configured Podman release.

#### Scenario: Reviewing the configured Podman network stack
- **WHEN** a maintainer reviews the Podman role inputs and provisioning-input inventory
- **THEN** they can identify Podman v6.1.1, Netavark v2.1.0, Aardvark-DNS v2.1.0, compatibility rationale, authoritative release sources, and integrity mechanisms

## ADDED Requirements

### Requirement: Rootless user storage configuration
The Podman provisioning role SHALL configure user-owned rootless storage with the overlay driver, a runtime directory under the selected user's runtime directory, a graph root under that user's home directory, and `/usr/bin/fuse-overlayfs` as the overlay mount program. The role SHALL NOT reset, move, or delete existing Podman storage while applying this configuration.

#### Scenario: Provisioning rootless Podman storage
- **WHEN** the role configures a selected rootless Podman user
- **THEN** it writes a user-owned `~/.config/containers/storage.conf` with the managed runtime and graph-root paths

#### Scenario: Existing rootless storage is present
- **WHEN** the user already has Podman images, containers, networks, or volumes
- **THEN** the role does not invoke a storage reset or delete those resources
