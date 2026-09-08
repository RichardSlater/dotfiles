## Context

The package role currently provides a `packages` value in `vars/main.yml`. Role vars override `group_vars/all.yml`, so the role installs only `btop` and `dnsutils` rather than the full declared inventory list, including ShellCheck.

## Goals / Non-Goals

**Goals:**
- Make the inventory `packages` list the effective source of package selections.
- Preserve an empty default for callers that do not define `packages`.
- Ensure the configured ShellCheck package is installed when provisioning runs.

**Non-Goals:**
- Pin operating-system package versions.
- Change package-manager sources or install packages outside Ansible.

## Decisions

- Remove the role-level `packages` definition. Role defaults already provide an empty fallback and inventory variables have the intended caller-level scope. This avoids duplicating the package list in a higher-precedence location.
- Retain `shellcheck` in `group_vars/all.yml` as the declarative inventory input. Adding it to role vars would still hide the remaining inventory packages.

## Risks / Trade-offs

- [Callers relying on the old two-package override receive the inventory list instead] → The role is invoked by the repository playbook with the repository inventory, which is the intended source of truth.
- [Distribution package availability varies] → Continue using the existing distribution package manager without version pins.

## Migration Plan

1. Remove the overriding role variable.
2. Run the package role or full playbook to install the effective inventory list.
3. Confirm `shellcheck` resolves on `PATH`.

Rollback restores the previous role variable, though that reintroduces the inventory override.

## Open Questions

None.
