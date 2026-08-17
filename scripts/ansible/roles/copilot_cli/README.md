# GitHub Copilot CLI

This role installs the official [`@github/copilot`](https://www.npmjs.com/package/@github/copilot) npm package at an exact version in the user's local prefix.

## Defaults

```yaml
copilot_cli_enabled: true
copilot_cli_package: "@github/copilot"
copilot_cli_version: "1.0.80"
copilot_cli_tarball_url: "https://registry.npmjs.org/@github/copilot/-/copilot-1.0.80.tgz"
copilot_cli_tarball_checksum: "sha512:ead7fddd9179e8a3a24d30232bf5212d9925d56e78dc8cda4d0972dbcf24a1c909645b30a514e7404234d18bda7296f7f434ef4d8bb7fe16bd49e2a9a3fa6065"
copilot_cli_install_prefix: "{{ ansible_facts['env'].HOME }}/.local"
copilot_cli_package_dir: "{{ copilot_cli_install_prefix }}/lib/node_modules/@github/copilot"
```

The role downloads the exact npm tarball and verifies its pinned SHA-512 digest before asking npm to install the local artifact. It deliberately does not use the floating `gh.io/copilot-install` script. The preceding `nvm` role provisions Node.js `v24.19.0`; this role invokes only its `nvm_npm_executable` path and fails explicitly if that runtime is unavailable.

When upgrading, the role temporarily preserves both an existing `~/.local/bin/copilot` entry point and an npm package payload, verifies the new installation, then removes the recovery directory. If installation fails, it removes partial new files and restores both prior artifacts instead of using npm's `--force` option. Authentication remains an interactive Copilot operation after provisioning.
