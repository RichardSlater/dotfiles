# pnpm

Ansible role to install [pnpm](https://pnpm.io/) from the official installer script.

## Defaults

```yaml
pnpm_version: "12.3.4"
pnpm_install_url: "https://get.pnpm.io/install.sh"
pnpm_home: "{{ ansible_facts['env'].HOME }}/.local/share/pnpm"
pnpm_global_packages: []
```

The installer receives the exact `PNPM_VERSION` value and the role verifies the resulting executable version. The official installer endpoint does not publish an independently authoritative checksum for the script; this is a maintainer-approved bounded TLS/source exception recorded in `docs/COMPONENT_VERSION_INVENTORY.md`.

## Global packages

Set `pnpm_global_packages` to package/version specs passed to `pnpm install --global`:

```yaml
pnpm_global_packages:
  - "@fission-ai/openspec@latest"
  - "typescript@5.9.3"
```

## Notes

- `pnpm_version` is pinned to the current `pnpm@latest` version at the time this role was added.
- The role installs only when pnpm is missing or installed version differs from `pnpm_version`.
- `pnpm_global_packages` entries are installed after pnpm itself is verified.
- Shell PATH integration is handled by the Chezmoi-managed shell config.
