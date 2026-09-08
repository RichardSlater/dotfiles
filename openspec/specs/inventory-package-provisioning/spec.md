## ADDED Requirements

### Requirement: Inventory package list is effective
The package role SHALL install every package declared in the caller's `packages` variable and MUST NOT override that variable with a role variable.

#### Scenario: Inventory declares developer tools
- **WHEN** the playbook runs the package role with the repository group variables
- **THEN** the package manager receives the full declared package list

### Requirement: ShellCheck is provisioned
The repository inventory SHALL declare `shellcheck` as a system package.

#### Scenario: Provisioning completes on a supported Debian host
- **WHEN** the package role completes successfully with the repository group variables
- **THEN** the `shellcheck` executable is installed and available on `PATH`
