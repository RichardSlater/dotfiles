## Plan: Refresh Dotfile Tool Pins

Update the repository’s explicit tool/version pins to current stable releases as of **2026-05-15**, while leaving schema/config versions and intentional `latest` installers unchanged.

**Steps**

1. **Classify scope**
   - Update: Ansible tool pins, checksums, pre-commit revs, legacy Debian helper script constants.
   - Leave unchanged: VS Code task schema, LazyVim schema versions, Oh My Posh theme schema, OS version guards, `min_ansible_version`, dynamic `latest` installer roles.

2. **Update Ansible tool pins**
   - `scripts/ansible/playbook.yml`
     - Keep `go_version: "1.26.3"`; it is current.
     - Fix stale comment.
     - Update `go_checksum` to `2b2cfc7148493da5e73981bffbf3353af381d5f93e789c82c79aff64962eb556`.
   - `scripts/ansible/roles/gh/vars/main.yml`
     - `v2.64.0` → `v2.92.0`.
   - `scripts/ansible/roles/podman/vars/main.yml`
     - `v5.3.1` → `v5.8.2`.
   - `scripts/ansible/roles/pwsh/vars/main.yml`
     - `7.5.4` → `7.6.1`.
   - `scripts/ansible/roles/uv/defaults/main.yml`
     - `0.9.22` → `0.11.14`.
     - Update Linux x64 checksum to `sha256:f3b623eb0e6141a7053d571d59a0bdc341e0f238ea8f5f0b4815ddbec9a2a296`.
   - `scripts/ansible/roles/oh-my-posh/defaults/main.yml`
     - `v29.0.1` → `v29.13.1`.
     - Update amd64 checksum after re-confirming from upstream `checksums.txt`.
   - `scripts/ansible/roles/nvm/defaults/main.yml`
     - `v0.40.3` → `v0.40.4`.
     - Recompute `install.sh` checksum from raw upstream at that tag.

3. **Update pre-commit hooks**
   - `.pre-commit-config.yaml`
     - `pre-commit/pre-commit-hooks`: `v4.6.0` → `v6.0.0`.
     - `adrienverge/yamllint`: `v1.35.1` → `v1.38.0`.

4. **Update legacy Debian helper scripts**
   - `scripts/debian/private_executable_install_bat.sh`
     - `BAT_VER="0.24.0"` → `0.26.1`.
   - `scripts/debian/private_executable_install_pwsh.sh`
     - `PWSH_VERSION="7.4.6"` → `7.6.1`.
   - `scripts/debian/private_executable_install_go.sh`
     - `go1.24.2.linux-amd64.tar.gz` → `go1.26.3.linux-amd64.tar.gz`.
   - Leave `scripts/debian/private_executable_install_taskctl.sh` unchanged; `1.7.5` is current.

5. **Keep intentional dynamic/current items**
   - Keep Dive at `v0.13.1`; current.
   - Keep tmux at `3.6a`; current.
   - Keep Copilot CLI and Gemini CLI as `latest`.
   - Keep Neovim/fzf source-based roles unchanged unless converting them to pinned tags is explicitly desired.

**Verification**

1. Run `Test Ansible Playbook - Syntax Check (Docker)`.
2. Run `Test Dotfiles - Dry Run (Docker)`.
3. Run `Shell Lint (shellcheck)`.
4. Run `pre-commit run --all-files` if dependencies are available.
5. Optionally run `Test Ansible Playbook - Full Apply (Docker)` for installer validation.
6. Run `chezmoi diff` and, if available, `chezmoi doctor`.

**Decisions**

- Include explicit version/checksum pins only.
- Exclude schema/config versions and GitHub Actions updates.
- Preserve intentional `latest` behavior for roles designed that way.
