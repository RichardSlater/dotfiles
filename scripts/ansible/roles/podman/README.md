# podman

Ansible role to build and install Podman from source and configure rootless operation.

## Requirements

- Ansible 2.9 or newer
- Debian or Ubuntu
- Go installed and available at `/usr/local/go/bin`
- `become: true` for the system and rootless configuration steps

## Role Variables

User-overridable variables from `defaults/main.yml`:

```yaml
podman_version: "v6.0.2"
podman_build_dir: "/tmp/podman_build"
podman_network_handler: "pasta"
podman_runtime: "crun"
podman_container_image_commit: "08ce6b4207e7b151ea1c2830cdb1d4473cfd12aa"
```

Internal variables from `vars/main.yml`:

```yaml
podman_git_repo: "https://github.com/containers/podman.git"

podman_package_map:
  pasta: "passt"
  slirp4netns: "slirp4netns"
  crun: "crun"
  runc: "runc"

podman_build_tags: "seccomp apparmor"
podman_user: "{{ ansible_env.SUDO_USER | default(ansible_user_id) }}"
```

## Version Strategy

This role uses a pinned Git tag and builds Podman from source, then configures rootless networking and user-level container settings. It removes the distribution `podman` and `podman-docker` packages so `/usr/local/bin/podman` is the only installation, and installs `/usr/local/bin/docker` as a Docker-compatible wrapper for it.

## Example Playbook

```yaml
- hosts: localhost
  become: true
  roles:
    - podman
```

Override the pinned version or runtime choices:

```yaml
- hosts: localhost
  become: true
  vars:
    podman_version: "v6.0.2"
    podman_network_handler: "slirp4netns"
    podman_runtime: "runc"
  roles:
    - podman
```

## Notes

- The role configures `/etc/containers/policy.json` and `/etc/containers/registries.conf` from `containers/image` at the reviewed immutable `podman_container_image_commit`. The project does not publish individual file checksums, so the full commit identity and TLS are the documented integrity boundary; see [`docs/PROVISIONING_INPUTS.md`](../../../../docs/PROVISIONING_INPUTS.md).
- Configuration is downloaded and validated in a staging directory. Existing managed configuration is backed up and restored if download, validation, or replacement fails.
- Rootless configuration includes `subuid` and `subgid` entries, user container config, and the unprivileged user namespace sysctl when available.
- On WSL, the role forces the Podman firewall driver to `iptables`.

## License

MIT
