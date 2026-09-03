## ADDED Requirements

### Requirement: Verified mise provisioning
The Ansible playbook SHALL provision mise in the target user's environment through a dedicated unprivileged role. The role SHALL install only a configured exact upstream release artifact and SHALL verify that artifact using its publisher-provided checksum before installing it.

#### Scenario: Fresh installation on a supported architecture
- **WHEN** the user-level Ansible provisioning play runs on an architecture with a configured mise artifact
- **THEN** it verifies and installs the configured mise version in a user-owned location

#### Scenario: Existing matching installation
- **WHEN** the configured mise version is already installed in the target user's location
- **THEN** the role completes without downloading or replacing the executable

#### Scenario: Artifact integrity mismatch
- **WHEN** the downloaded mise artifact does not match its configured publisher-provided checksum
- **THEN** the role fails without installing or activating the artifact

### Requirement: Supported architecture enforcement
The mise role SHALL use only reviewed architecture-specific artifacts and SHALL fail before downloading or modifying the installation when the host architecture has no configured artifact.

#### Scenario: Unsupported architecture
- **WHEN** the mise role runs on an architecture without a reviewed artifact mapping
- **THEN** it reports that the architecture is unsupported and does not download or install mise

### Requirement: User shell availability
Provisioning SHALL configure supported interactive user shells so that the mise executable and mise-managed tool shims are available in a new shell session without manually setting paths.

#### Scenario: New supported shell session
- **WHEN** a user opens a supported interactive shell after provisioning
- **THEN** the shell can resolve the mise executable and the mise shims path is active

### Requirement: Reviewed provisioning-input documentation
The repository SHALL document the mise release identity, authoritative source, checksum mechanism, and supported architectures or exceptions in the provisioning-input inventory.

#### Scenario: Reviewing the mise dependency
- **WHEN** a maintainer reviews `docs/PROVISIONING_INPUTS.md`
- **THEN** they can identify the configured mise release and its integrity boundary
