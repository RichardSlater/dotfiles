# cargo

Ansible role to install a curated set of Rust CLI tools with `cargo install`.

## Requirements

- Ansible 2.9 or newer
- A working Rust toolchain with Cargo already installed
- The user environment must be able to source `$HOME/.cargo/env`

## Role Variables

User-overridable variables from `defaults/main.yml`:

```yaml
cargo_packages:
  - name: tree-sitter-cli
    binary: tree-sitter
  - name: ripgrep
    binary: rg
  - name: fd-find
    binary: fd
  - name: zoxide
  - name: du-dust
    binary: dust
  - name: procs
  - name: gping
```

Each package entry can override the binary name used for verification when it differs from the crate name.

## Version Strategy

This role installs the latest available crate versions from crates.io. It does not pin crate versions today.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - cargo
```

Override the installed package set:

```yaml
- hosts: localhost
  vars:
    cargo_packages:
      - name: ripgrep
        binary: rg
      - name: zoxide
  roles:
    - cargo
```

## Notes

- The role verifies each installed binary by running `--version`.
- Idempotence and update behavior for `cargo install` are tracked as later hardening work.

## License

MIT
