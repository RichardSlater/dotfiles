# Ansible Role: Foundry

This role bootstraps the Foundry toolchain for the current user and keeps the install behavior predictable.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
foundry_enabled: true
foundry_install_root: "{{ ansible_env.HOME }}/.foundry"
foundry_bin_dir: "{{ foundry_install_root }}/bin"
foundry_update: false
```

## Behavior

- Installs the Foundry bootstrap script only when `foundryup` is missing.
- Runs `foundryup` when `forge` is not installed yet.
- Treats Foundry's rolling release model as install-if-missing by default.
- Runs `foundryup` again only when `foundry_update: true` is set explicitly.

## Example

```yaml
- hosts: localhost
  roles:
    - foundry
```

To force an update on a later run:

```yaml
- hosts: localhost
  vars:
    foundry_update: true
  roles:
    - foundry
```
