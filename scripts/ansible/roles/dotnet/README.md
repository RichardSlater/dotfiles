# dotnet

Installs a reviewed exact .NET SDK archive into the invoking user's local
`~/.dotnet` directory.

## Requirements

- Ansible 2.9 or newer
- Linux `x86_64` or `aarch64`
- Internet access to Microsoft's SDK archive host

## Role Variables

User-overridable variables from `defaults/main.yml`:

```yaml
dotnet_sdk_version: "10.0.400"
dotnet_install_dir: "{{ ansible_env.HOME }}/.dotnet"
dotnet_artifacts:
  x86_64:
    url: "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.400/dotnet-sdk-10.0.400-linux-x64.tar.gz"
    checksum: "sha512:<publisher-sha-512>"
```

`dotnet_artifacts` contains the reviewed Linux x64 and arm64 assets and their
publisher SHA-512 checksums. Unsupported architectures fail before any download
or change to an existing installation.

## Installation and recovery behavior

The role downloads with Ansible checksum verification, extracts into a staging
directory, and atomically activates the staged SDK. If activation or the exact
version check fails, it restores the previous user-local installation. An
existing `.ansible-backup` recovery path causes a safe failure rather than being
overwritten.

The selected assets, checksums, and their Microsoft release-metadata source are
recorded in [`docs/PROVISIONING_INPUTS.md`](../../../../docs/PROVISIONING_INPUTS.md).

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - dotnet
```

## Validation

```sh
cd scripts/ansible
ansible-playbook -i inventory/hosts.yml tests/dotnet-failure-path.yml
```

## License

MIT
