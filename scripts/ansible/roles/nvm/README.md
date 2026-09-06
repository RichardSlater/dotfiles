# nvm

Ansible role to install Node Version Manager from a versioned upstream GitHub installer script.

## Defaults

```yaml
nvm_version: "v0.40.6"
nvm_install_url: "https://raw.githubusercontent.com/nvm-sh/nvm/{{ nvm_version }}/install.sh"
nvm_install_checksum: "sha256:2ef7e8d4373c1ffd70daa55f919f629e98a619543ffc0a8d892d77a5247e50e4"
nvm_ref: "b6cf55f6adf3b953d0e5e00a4049444e300e3af8"
nvm_dir: "{{ ansible_facts['env'].HOME }}/.nvm"
nvm_node_version: "v24.20.0"
nvm_node_bin: "{{ nvm_dir }}/versions/node/{{ nvm_node_version }}/bin"
nvm_node_executable: "{{ nvm_node_bin }}/node"
nvm_npm_executable: "{{ nvm_node_bin }}/npm"
```

The role installs the exact Node.js LTS version through nvm and verifies both the Node.js and npm executables. These stable paths are intended for dependent Ansible tasks; they must not be replaced with distribution-managed `node` or bare `npm`.

The nvm installer is pinned to a release URL and a repository-verified SHA-256 digest. The role also verifies that the installed Git checkout resolves to the signed release's immutable commit. nvm performs its own checksum validation when installing the exact Node.js release. The installer is removed after execution and shell integration remains in the Chezmoi-managed shell config.
