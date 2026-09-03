## ADDED Requirements

### Requirement: Reviewed Podman network-helper compatibility set
The Podman provisioning role SHALL define an exact reviewed compatibility set containing the pinned source-built Podman version and matching exact Netavark and Aardvark-DNS versions. The configured Netavark and Aardvark-DNS versions SHALL have matching major-minor versions and SHALL be compatible with the configured Podman release.

#### Scenario: Reviewing the configured Podman network stack
- **WHEN** a maintainer reviews the Podman role inputs and provisioning-input inventory
- **THEN** they can identify the exact Podman, Netavark, and Aardvark-DNS versions, compatibility rationale, authoritative release sources, and integrity mechanisms

### Requirement: Verified source-built network helpers
The Podman provisioning role SHALL install Netavark and Aardvark-DNS from configured immutable upstream release artifacts using their publisher-provided SHA-256 digests. The role SHALL verify each artifact before installing its executable and SHALL verify each installed helper reports its configured exact version.

#### Scenario: Fresh installation on a supported architecture
- **WHEN** the Podman role provisions a host with a reviewed helper artifact mapping
- **THEN** it verifies and installs the configured Netavark and Aardvark-DNS executables in the source-built Podman helper location

#### Scenario: Helper artifact integrity mismatch
- **WHEN** a Netavark or Aardvark-DNS artifact does not match its configured SHA-256 digest
- **THEN** the role fails without installing that artifact or replacing an existing managed helper

#### Scenario: Unsupported helper architecture
- **WHEN** the Podman role runs on an architecture without reviewed Netavark and Aardvark-DNS artifacts
- **THEN** it fails before downloading or replacing either helper

### Requirement: Managed helper resolution
The Podman provisioning role SHALL make the active source-built Podman executable resolve the verified managed Netavark and Aardvark-DNS helpers rather than distribution-provided helper binaries. The role SHALL not use distribution Netavark or Aardvark-DNS packages as the helper source for the source-built Podman installation.

#### Scenario: Verifying active helper selection
- **WHEN** the role completes successfully on a supported rootless host
- **THEN** a direct Podman network operation uses the configured compatible Netavark helper without an unsupported-subcommand error

### Requirement: Rootless network lifecycle validation
The repository SHALL provide focused validation that exercises rootless Podman network creation and removal independently of Compose after helper provisioning.

#### Scenario: Rootless network lifecycle succeeds
- **WHEN** the configured compatible helper set is installed on a supported rootless host
- **THEN** the validation creates and removes an isolated diagnostic network successfully

#### Scenario: Existing Podman storage is preserved
- **WHEN** the role updates an incompatible helper set
- **THEN** it does not run a Podman storage reset or delete existing user containers, images, networks, or volumes
