# Oxlint role

Installs the standalone [Oxlint](https://oxc.rs/docs/guide/usage/linter) binary
for the provisioned user. The role downloads an exact Oxc GitHub release asset
and verifies its SHA-256 digest before installing it to `~/.local/bin/oxlint`.

## Variables

- `oxlint_version`: pinned Oxlint version (`1.81.0`).
- `oxlint_install_dir`: user-local binary directory.
- `oxlint_artifacts`: reviewed Linux artifacts keyed by Ansible architecture.

Only `x86_64` and `aarch64` GNU/Linux assets are currently reviewed. The role
fails before downloading on another architecture.
