## MODIFIED Requirements

### Requirement: Documented integrity boundary
Every direct external artifact or immutable-source exception introduced by this change SHALL be documented with its version or commit, source, integrity mechanism, supported architectures where applicable, and any authoritative-checksum limitation. The inventory SHALL identify Podman v6.1.1 and the Netavark and Aardvark-DNS v2.1.0 artifacts with their reviewed SHA-256 verification values.

#### Scenario: Reviewing managed provisioning inputs
- **WHEN** a maintainer reviews the component-version inventory
- **THEN** they can identify each changed component's selected identity, source, integrity mechanism, and documented exception
