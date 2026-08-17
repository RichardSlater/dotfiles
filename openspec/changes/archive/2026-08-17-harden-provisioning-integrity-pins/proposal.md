## Why

Several provisioning paths still resolve mutable or unverified inputs: Ansible collections float, .NET uses a channel installer, and Podman imports container-image configuration from GitHub's moving `main` branch. This makes home-profile rebuilds less reproducible and weakens the supply-chain guarantees already applied to Neovim, nvm, and Copilot CLI.

## What Changes

- Pin compatible Ansible collection releases in `requirements.yml` and verify the resolved collection set during provisioning validation.
- Replace the .NET channel installer with an exact, architecture-specific SDK archive and publisher checksum verification.
- Replace Podman's mutable container-image configuration source with an immutable, validated upstream commit reference.
- Reconcile the explicitly declared Neovim plugins, lazy.nvim bootstrap revision, and `lazy-lock.json` so all declared plugins resolve to reviewed immutable commits.
- Document the selected versions, integrity sources, supported architectures, and intentional exceptions.

## Capabilities

### New Capabilities

- `reproducible-provisioning-inputs`: Provisioning consumes reviewed, immutable, integrity-verified external artifacts and dependency releases.
- `neovim-plugin-lock-consistency`: Neovim's declared plugin sources and lockfile consistently resolve to reviewed immutable revisions.

### Modified Capabilities

- None.

## Impact

- Affects Ansible requirements, the .NET and Podman roles, Neovim configuration and lockfile, and version/integrity documentation.
- Requires fresh publisher metadata for every selected release, checksum, and immutable commit before implementation.
- Does not change Chezmoi identity data, Git email configuration, signing keys, or work-profile settings.
