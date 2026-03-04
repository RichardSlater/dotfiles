# gemini-cli

Ansible role to install the [Google Gemini CLI](https://github.com/google-gemini/gemini-cli).

## Requirements

The target system must have `npm` (Node Package Manager) installed, as the Gemini CLI is distributed as an npm package. Ensure Node.js (version 18 or higher) and npm are installed prior to running this role.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Whether to install gemini-cli
gemini_cli_enabled: true

# Version to install - can be "latest" or a specific version
gemini_cli_version: "latest"

# Installation prefix for global npm packages
# Defaults to user's .local directory for non-root installation
gemini_cli_install_prefix: "{{ ansible_env.HOME }}/.local"
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: gemini-cli
```

## License

MIT
