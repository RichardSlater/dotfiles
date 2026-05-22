# antigravity-cli

Ansible role to install the [Google Antigravity CLI](https://github.com/google-antigravity/antigravity-cli).

## Requirements

The target system must have `curl` installed. The official Linux installer downloads the latest `agy` binary into `~/.local/bin` by default.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
antigravity_cli_enabled: true
antigravity_cli_install_prefix: "{{ ansible_env.HOME }}/.local"
antigravity_cli_install_dir: "{{ antigravity_cli_install_prefix }}/bin"
antigravity_cli_binary_name: agy
antigravity_cli_install_script_url: https://antigravity.google/cli/install.sh
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: antigravity-cli
```

## License

MIT
