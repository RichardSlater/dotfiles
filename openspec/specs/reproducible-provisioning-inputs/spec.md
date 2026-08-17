# Reproducible Provisioning Inputs

## Purpose

Ensure direct provisioning dependencies resolve to reviewed immutable releases or commits with documented integrity verification and exceptions.

## Requirements

### Requirement: Reviewed Ansible collection resolution
The provisioning requirements file SHALL declare an exact version for every Ansible collection consumed by the repository.

#### Scenario: Fresh collection installation
- **WHEN** provisioning dependencies are installed from `scripts/ansible/requirements.yml`
- **THEN** the installer resolves each declared collection to its exact reviewed version

### Requirement: Verified .NET SDK artifact installation
The .NET role SHALL install only a reviewed exact SDK archive for a supported architecture and SHALL verify the archive against the publisher-provided checksum before extraction.

#### Scenario: Supported architecture with valid archive
- **WHEN** the host architecture has a configured official SDK URL and matching publisher checksum
- **THEN** the role verifies the archive before extracting it and confirms the installed SDK matches the configured exact version

#### Scenario: Unsupported architecture
- **WHEN** the host architecture has no reviewed SDK artifact configuration
- **THEN** the role fails before downloading or changing the existing SDK installation

#### Scenario: Archive integrity mismatch
- **WHEN** the downloaded SDK archive does not match the configured publisher checksum
- **THEN** the role fails without extracting or activating the archive

### Requirement: Immutable Podman configuration source
The Podman role SHALL retrieve external container-image configuration only from reviewed immutable upstream revision URLs, not mutable branch URLs.

#### Scenario: Provisioning container-image configuration
- **WHEN** the Podman role retrieves a managed external configuration file
- **THEN** its source URL identifies the configured immutable upstream revision

### Requirement: Documented integrity boundary
Every direct external artifact or immutable-source exception introduced by this change SHALL be documented with its version or commit, source, integrity mechanism, supported architectures where applicable, and any authoritative-checksum limitation.

#### Scenario: Reviewing managed provisioning inputs
- **WHEN** a maintainer reviews the component-version inventory
- **THEN** they can identify each changed component's selected identity, source, integrity mechanism, and documented exception
