## 1. Review and configure the release input

- [x] 1.1 Research the latest applicable stable mise release, official architecture-specific artifacts, and publisher-provided SHA-256 checksums.
- [x] 1.2 Add exact mise version, user-owned install location, and reviewed artifact URL/checksum mappings to shared Ansible variables.
- [x] 1.3 Record the selected mise identity, authoritative source, integrity mechanism, and supported architecture coverage in `docs/PROVISIONING_INPUTS.md`.

## 2. Implement user-level provisioning

- [x] 2.1 Create the `scripts/ansible/roles/mise/` role with defaults and tasks that reject unsupported architectures before downloading.
- [x] 2.2 Implement idempotent download, checksum verification, installation, and installed-version verification for mise.
- [x] 2.3 Add `mise` to the unprivileged user-role sequence in `scripts/ansible/playbook.yml`.

## 3. Configure shell integration

- [x] 3.1 Identify the Chezmoi-managed supported shell initialization sources and add minimal mise activation and shims-path configuration there.
- [x] 3.2 Ensure the shell configuration is idempotent and does not take ownership of rendered dotfiles from Ansible.
- [x] 3.3 Document mise's role and shell activation behavior in the Ansible layout documentation.

## 4. Validate provisioning

- [x] 4.1 Add or update focused tests for supported-architecture installation, existing matching version, unsupported architecture, and checksum mismatch behavior.
- [x] 4.2 Run `ansible-playbook playbook.yml --syntax-check` from `scripts/ansible` after installing declared Galaxy requirements.
- [x] 4.3 Run the applicable repository provisioning tests and verify a new supported shell session resolves mise and its shims.
