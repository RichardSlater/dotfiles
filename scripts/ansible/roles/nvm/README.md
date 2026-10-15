# nvm

Ansible role to install Node Version Manager from a versioned upstream GitHub installer script.

## Defaults

```yaml
nvm_version: "v0.40.8"
nvm_install_url: "https://raw.githubusercontent.com/nvm-sh/nvm/{{ nvm_version }}/install.sh"
nvm_install_checksum: "sha256:48a0eee9a60e07422dce0eb5774754c83889570ca1ee2566c516acbe8af03a9e"
nvm_ref: "a885b885fef16fac4bc544188fb25e9e37ae83e8"
nvm_dir: "{{ ansible_facts['env'].HOME }}/.nvm"
nvm_node_version: "v26.12.0"
nvm_node_bin: "{{ nvm_dir }}/versions/node/{{ nvm_node_version }}/bin"
nvm_node_executable: "{{ nvm_node_bin }}/node"
nvm_npm_executable: "{{ nvm_node_bin }}/npm"
```

The role installs the exact stable Node.js Current release through nvm and verifies both the Node.js and npm executables. These stable paths are intended for dependent Ansible tasks; they must not be replaced with distribution-managed `node` or bare `npm`.

The nvm installer is pinned to a release URL and a repository-verified SHA-256 digest. The role also verifies that the installed Git checkout resolves to the signed release's immutable commit. nvm performs its own checksum validation when installing the exact Node.js release. The installer is removed after execution and shell integration remains in the Chezmoi-managed shell config.
