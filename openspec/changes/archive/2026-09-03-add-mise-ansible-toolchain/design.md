## Context

The Ansible playbook currently provisions individual language runtimes and developer CLIs through separate user roles. `uv` demonstrates the repository convention for direct user-local binary installation: resolve a fixed release per supported architecture, verify its publisher checksum with `get_url`, install only after verification, and confirm the resulting version. The repository also requires external provisioning inputs to be documented in `docs/PROVISIONING_INPUTS.md`.

mise is intended to provide a consistent user-local layer for managing and activating development toolchains. It must be installed without privilege escalation and integrated without replacing the existing runtime roles in this change.

## Goals / Non-Goals

**Goals:**

- Provision a reviewed, exact mise release for supported Linux architectures through an idempotent Ansible role.
- Verify the downloaded release artifact before installing its executable.
- Make mise and its shims available in supported user shells after provisioning.
- Retain the repository's documented integrity boundary for externally fetched inputs.

**Non-Goals:**

- Migrating existing Node.js, Bun, Rust, Go, .NET, Python, or other runtime roles to mise.
- Defining project-specific mise tool versions or adding a repository `mise.toml`.
- Installing mise system-wide, modifying distribution-managed packages, or managing user dotfiles outside the Chezmoi source tree.

## Decisions

### Use a dedicated user-level `mise` Ansible role

The role will live under `scripts/ansible/roles/mise/` and be called from the existing unprivileged user-role play. This keeps installation ownership, defaults, tasks, and tests aligned with the repository role layout and preserves the privilege boundary. Adding ad-hoc tasks directly to `playbook.yml` was considered but rejected because it would make configuration and validation harder to maintain.

### Install a pinned upstream release with publisher checksum verification

Shared variables will declare an exact mise version plus architecture-specific release URLs and checksums. The role will download with Ansible checksum enforcement, install to a user-owned location, and verify the installed version. The official installation script and a mutable “latest” release URL were rejected because they do not provide the repository's required immutable identity and verified-artifact boundary.

### Use mise shell activation and shims instead of changing runtime ownership

The role will configure shell integration in Chezmoi-managed shell configuration so mise's executable and shims are available in interactive sessions. Existing provisioned runtimes remain untouched, avoiding a migration risk while allowing future changes to adopt mise deliberately. Editing rendered shell files from Ansible was rejected because the Ansible layout explicitly assigns dotfile ownership to Chezmoi.

### Fail clearly for unsupported architectures

The role will map only architectures with reviewed upstream artifacts and fail before any download if the current architecture lacks a mapping. This follows the existing direct-artifact convention and prevents accidental unverified or incorrect binary installation.

## Risks / Trade-offs

- [mise activation can change command resolution in user shells] → Add only the minimal supported-shell integration and validate that activation makes the mise command and shims available; do not migrate existing runtimes in this change.
- [Upstream release naming or checksum publication changes] → Resolve the release metadata during implementation, store exact reviewed values, and document the authoritative source and integrity boundary.
- [New architectures lack reviewed artifacts] → Fail with an actionable unsupported-architecture message rather than selecting a fallback binary.
- [Shell changes conflict with dotfile ownership] → Make all shell-init changes in the Chezmoi source tree and keep Ansible responsible solely for provisioning.
