## Context

The Podman role removes the distribution Podman package, builds pinned Podman `v6.0.2` with `PREFIX=/usr/local`, and installs Debian's unpinned `netavark` and `aardvark-dns` packages. The active host therefore runs `/usr/local/bin/podman` 6.0.2 with `/usr/lib/podman/netavark` 1.14.0. A direct rootless `podman network create` call proves the incompatibility: Podman invokes Netavark `create`, which Netavark 1.14.0 rejects. Upstream Netavark v2.0.0 states it is required for Podman 6.0 and that the versions must be updated together.

This role already owns the source-built Podman boundary, so it must also own the helpers that implement Podman's networking protocol.

## Goals / Non-Goals

**Goals:**

- Provision Netavark and Aardvark-DNS v2.0.0 as a reviewed pair for Podman v6.0.2.
- Verify upstream release artifacts with their published SHA-256 digests before installation.
- Ensure source-built Podman resolves the managed helpers rather than Debian's 1.14.x binaries.
- Validate the rootless network lifecycle independently of Compose.

**Non-Goals:**

- Upgrading Podman beyond the existing v6.0.2 pin.
- Migrating Podman to a distribution package or adding an external package repository.
- Resetting Podman storage, or deleting user containers, images, networks, or volumes.
- Changing Compose files or treating Compose as the network-backend fix.

## Decisions

### Provision upstream release binaries with checksum enforcement

The role will use the immutable v2.0.0 GitHub release URLs and release-asset SHA-256 digests for `netavark.gz` and `aardvark-dns.gz`. It will download to a temporary staging directory with checksum enforcement, decompress the verified artifacts, install executable binaries in the source-built Podman helper location, and verify their reported versions.

This avoids using an unpinned distribution helper version with a source-built Podman protocol. Building the Rust projects from source was rejected because it adds Rust toolchain, dependency-resolution, and reproducibility complexity without improving the release-artifact integrity boundary.

### Keep the three networking components in an explicit compatibility set

The role will document and centralize the Podman, Netavark, and Aardvark-DNS versions as one reviewed compatibility set. Netavark and Aardvark-DNS will use matching `2.0` major-minor versions, as required by upstream. A future Podman update must review and update all three inputs together.

### Explicitly control helper resolution

The role will configure or install helpers at the location selected by the `/usr/local` Podman build and verify from the active rootless Podman command path that Netavark v2 is used. It will remove the Debian helper packages from the Podman role's dependency source so package resolution cannot silently restore the incompatible helper pair.

Installing the helpers only on `PATH` was rejected because Podman helper discovery does not depend solely on interactive-shell path ordering.

### Treat failures as transactional

The role will stage downloads and ensure temporary artifacts are removed on success and failure. It will not replace existing managed helpers until verification succeeds. Version or checksum failures will stop provisioning with an actionable message.

## Risks / Trade-offs

- [The release assets are Linux x86_64 binaries] → Explicitly support only reviewed architectures and fail before download elsewhere until additional reviewed artifacts are available.
- [Helper replacement can disrupt a running Podman service] → Validate before replacement and document that active Podman workloads should be stopped before applying the role.
- [A second consumer depends on Debian's helper packages] → Inspect package reverse dependencies before removal and scope package removal to helpers installed solely by this role.
- [Future Podman changes require a newer helper protocol] → Store the compatibility set in shared role inputs and add a lifecycle test that detects protocol mismatches.
- [Rootless networking can fail for host-policy reasons after the protocol fix] → Keep the direct network lifecycle test separate from Compose and report post-alignment failures independently.

## Migration Plan

1. Record the Podman 6.0.2, Netavark 2.0.0, and Aardvark-DNS 2.0.0 compatibility set and publisher digests.
2. Add verified helper provisioning and controlled helper resolution to the Podman role.
3. Remove the role's dependency on distribution-provided Netavark and Aardvark-DNS after checking reverse dependencies.
4. Apply the role without resetting Podman storage.
5. Verify direct rootless network create/remove, then run the relevant Compose workflow.
6. If validation fails, restore the previously managed helper binaries; do not run `podman system reset` as a rollback mechanism.

## Open Questions

- Does any locally installed package other than this role require the Debian Netavark or Aardvark-DNS packages?
- Which `containers.conf` helper-binary setting is required on this Podman build to make `/usr/local` helper resolution explicit, rather than relying on compiled defaults?
- Are reviewed non-x86_64 v2.0.0 release artifacts available for architectures the role claims to support?
