## 1. Establish authoritative version and integrity inputs

- [x] 1.1 Record the current home-profile versions, collection inventory, .NET installation state, Podman configuration sources, and Neovim lockfile before making changes.
- [x] 1.2 Query official publishers for currently compatible Ansible collection releases, the selected .NET SDK archives and SHA-512 checksums, Podman container-image source commits, and Neovim plugin commits.
- [x] 1.3 Verify every selected release, checksum, and commit against an authoritative publisher source; document unavailable authoritative checksums as explicit exceptions.

## 2. Pin provisioning dependencies and .NET artifacts

- [x] 2.1 Add exact reviewed versions for every consumed Ansible collection in `scripts/ansible/requirements.yml`.
- [x] 2.2 Install the requirements into an isolated collection path and verify the resolved collection versions are exactly the declared versions.
- [x] 2.3 Refactor the .NET role defaults for a single exact SDK version, supported architecture map, official asset URLs, and publisher SHA-512 checksums.
- [x] 2.4 Refactor the .NET role tasks to reject unsupported architectures, verify the archive before extraction, stage or back up the existing user-local SDK, and restore it on failed installation.
- [x] 2.5 Verify the installed .NET SDK reports the exact configured version and add focused failure-path coverage for invalid architecture and checksum mismatch.

## 3. Pin Podman configuration sources

- [x] 3.1 Locate every Podman role download that references a mutable upstream branch and replace it with a reviewed immutable commit-derived source.
- [x] 3.2 Add content verification where publisher checksums are available; otherwise document the immutable-commit and TLS exception without fabricating a checksum.
- [x] 3.3 Preserve and restore existing Podman configuration when a replacement download or validation step fails.
- [x] 3.4 Add a focused validation that rejects mutable branch URLs in managed Podman configuration sources.

## 4. Reconcile Neovim plugin provenance

- [x] 4.1 Refresh lazy.nvim bootstrap to a reviewed immutable commit and make clone/checkout failures leave no partially initialized bootstrap directory.
- [x] 4.2 Reconcile every explicitly version-constrained plugin declaration with the same commit in `lazy-lock.json`.
- [x] 4.3 Validate `lazy-lock.json` as JSON and run clean headless Neovim startup plus plugin synchronization without leaving a partially updated lockfile.

## 5. Document and validate the full change

- [x] 5.1 Create or update the component-version inventory with sources, selected releases or commits, integrity mechanisms, supported architectures, and documented exceptions.
- [x] 5.2 Update role READMEs and architecture documentation to match the new dependency, .NET, Podman, and Neovim behavior.
- [x] 5.3 Run pre-commit on changed files, Ansible syntax and lint checks, isolated Galaxy requirements installation, focused role validation, and Neovim lock/startup checks.
- [x] 5.4 Review the final diff for email addresses, signing keys, work-domain configuration, secrets, and unintended identity-file changes.
