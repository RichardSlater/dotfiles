## Context

The home profile already validates selected direct downloads, and the recent nvm, Copilot CLI, and Neovim build changes establish safer recovery patterns. However, Ansible collections remain floating, the .NET role executes a mutable channel installer, Podman imports configuration from a moving upstream branch, and Neovim's explicit plugin declarations are not uniformly represented by immutable revisions in the lockfile.

This change must preserve the home profile's separate identity configuration. Artifact versions, checksums, release tags, commits, and package metadata must be freshly collected from authoritative publisher sources immediately before implementation; the older work-profile snapshot is evidence of an approach, not an authoritative version inventory.

## Goals / Non-Goals

**Goals:**

- Make the selected external provisioning inputs reproducible, immutable, and verifiable.
- Fail before executing, extracting, or installing an unsupported or integrity-mismatched artifact.
- Preserve installed tooling when an upgrade step fails where practical.
- Keep source, checksum, architecture, and exception documentation aligned with implementation.
- Maintain a coherent reviewed Neovim plugin inventory.

**Non-Goals:**

- Update every package, role, or tool in the repository.
- Invent checksums where the publisher does not provide one.
- Change Git identity, signing keys, email addresses, providers, models, or work-profile configuration.
- Treat distribution-managed APT packages as individually reproducible artifacts.

## Decisions

### Pin Ansible collections to reviewed compatible releases

`requirements.yml` will contain exact collection versions and implementation validation will install the declared requirements into an isolated path before syntax and lint checks.

- **Rationale:** Galaxy collection releases can otherwise drift between fresh installs despite role pins already being exact.
- **Alternative considered:** Leave collections floating and rely on lockfiles. Rejected because the repository has no generated collection lockfile consumed by normal provisioning.

### Install .NET from exact publisher assets with architecture-specific checksums

The .NET role will select a reviewed SDK version, official Linux x64/arm64 URLs, and the corresponding publisher SHA-512 values. It will assert supported architecture, download through `get_url` with the selected checksum, extract into the existing user-local install location, and verify the exact SDK version. The install path must be staged or backed up so a failed extraction does not leave a partial SDK as the active installation.

- **Rationale:** A channel installer selects a mutable release and executes an unverified script. Microsoft publishes SHA-512 for SDK archives; that format is used rather than fabricating SHA-256.
- **Alternative considered:** Retain `dotnet-install.sh` and pin only its URL. Rejected because the selected SDK remains channel-dependent and the execution boundary is wider.

### Pin Podman's container-image configuration source by immutable commit

The Podman role will replace every raw GitHub `main` configuration URL with a reviewed commit-derived URL. The commit identifier and source repository will be documented, and provisioning will validate downloaded content before installation using a publisher-derived checksum where available; if no authoritative checksum exists, the immutable commit and TLS boundary will be explicitly documented as an exception.

- **Rationale:** Branch URLs are mutable and can change without a repository change.
- **Alternative considered:** Continue using `main` for convenience. Rejected because it defeats reproducibility.

### Treat the Neovim lockfile as the plugin inventory

The implementation will refresh explicit plugin declarations, `lazy-lock.json`, and the lazy.nvim bootstrap to reviewed immutable commits in one update. Every plugin explicitly pinned in configuration will have a matching lock entry; an existing lock entry will not be changed without reconciling its declared source or documenting why it is transitive-only.

- **Rationale:** Pinning only selected Lua declarations leaves the actual resolved set ambiguous.
- **Alternative considered:** Pin selected declarations while retaining the stable branch bootstrap. Rejected because it retains a mutable root of trust.

## Risks / Trade-offs

- [Fresh releases supersede candidate work-profile values] → Query publisher APIs and manifests during implementation; record the actual selected values and do not reuse stale values.
- [A validated archive is unavailable for an architecture] → Assert the supported architecture set and fail before download.
- [An interrupted .NET upgrade leaves an unusable installation] → Stage extraction and perform an atomic swap or restore the prior installation in rescue handling.
- [Podman upstream reorganizes files at the pinned commit] → Validate each expected destination and file content before replacing local configuration.
- [Neovim pins become stale or incompatible] → Refresh lockfile and explicit declarations as one tested unit using headless Neovim startup and plugin synchronization.
- [Galaxy pins introduce a compatibility conflict] → Install requirements in isolation and run existing syntax/lint checks before accepting them.

## Migration Plan

1. Record current installed .NET, Podman configuration, collection inventory, and Neovim lockfile state.
2. Gather authoritative release metadata, checksums, and commit identities; reject mismatches.
3. Apply isolated collection validation and direct-download changes with failure-safe staging.
4. Refresh Neovim pins and verify a clean headless startup plus lock consistency.
5. Run provisioning syntax, lint, and focused idempotence checks.
6. On failure, restore the preserved .NET installation and Podman configuration, retain existing Neovim lockfile, and revert the configuration commit; collection pins can be reverted directly.

## Open Questions

- Which latest compatible .NET SDK release and publisher SHA-512 values are available when implementation begins?
- Does the selected Podman container-image source publish authoritative file checksums, or must the immutable-commit exception be documented?
- Which current collection versions remain compatible with the installed Ansible version and current role calls?
- Does a clean Neovim plugin synchronization require updating transitive lock entries beyond explicitly declared plugins?
