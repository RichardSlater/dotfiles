## Context

The role currently builds Podman v6.0.2 and installs checksum-verified Netavark and Aardvark-DNS v2.0.0 binaries. It already uses staging, rollback, and runtime network checks. The later upstream role upgrades that compatibility set to Podman v6.1.1 and helper v2.1.0, and adds a user-owned rootless storage configuration.

## Goals / Non-Goals

**Goals:**
- Install the reviewed Podman 6.1.1 and 2.1.0 network-helper set atomically.
- Preserve checksum verification, helper rollback, and rootless network diagnostics.
- Prevent rootless storage from falling back to root-owned paths.

**Non-Goals:**
- Migrate or delete existing Podman storage.
- Support unreviewed helper architectures.
- Adopt unrelated work-repository Pi configuration.

## Decisions

- Pin Podman to v6.1.1 and both helpers to v2.1.0 using the upstream-reviewed SHA-256 values. This keeps the helper pair on the matching release line; independent latest-version selection is rejected.
- Preserve the existing staging and rollback flow rather than replacing helpers in place. A failed download, decompression, or version assertion must leave existing helpers usable.
- Manage `storage.conf` in the selected rootless user's containers configuration. It sets the overlay driver, runtime directory, user-owned graph root, and `fuse-overlayfs` mount program. This is safer than changing global storage because user configuration has precedence and the role targets rootless operation.
- Retain the existing diagnostic network create/remove test. It validates the running stack rather than merely checking installed binaries.

## Risks / Trade-offs

- [Upgrade incompatibility with existing local state] → Do not reset storage; retain the diagnostic network lifecycle check and documented rollback path.
- [Unsupported architecture] → Continue failing before artifact download when no reviewed mapping exists.
- [Missing fuse-overlayfs] → The role already installs it as a system dependency before writing `storage.conf`.
- [Checksum or release mismatch] → Retain `get_url` SHA-256 verification and installed-version assertions.

## Migration Plan

1. Update Podman and helper pins together with their authoritative checksums and inventory documentation.
2. Provision normally; the role stages and validates helpers before replacing managed files.
3. Write the rootless storage configuration without moving or deleting existing data.
4. Confirm the active helper and isolated rootless network lifecycle.
5. On provisioning failure, use the existing helper rollback; restore the prior source pins for a release rollback. No storage reset is permitted.

## Open Questions

None.
