# Neovim Plugin Lock Consistency

## Purpose

Ensure Neovim's bootstrap and explicitly version-constrained plugins resolve to reviewed immutable commits that are consistent with `lazy-lock.json`.

## Requirements

### Requirement: Immutable Neovim bootstrap revision
The Neovim configuration SHALL bootstrap lazy.nvim from a reviewed immutable commit rather than a mutable branch or tag reference.

#### Scenario: Fresh lazy.nvim bootstrap
- **WHEN** lazy.nvim is absent from the Neovim data directory
- **THEN** the configuration clones the upstream repository and checks out the configured immutable commit before loading plugins

### Requirement: Consistent explicit plugin pins
Every explicitly version-constrained Neovim plugin declaration SHALL reference a reviewed immutable commit and SHALL have a corresponding entry in `lazy-lock.json` with the same commit.

#### Scenario: Checking an explicit plugin declaration
- **WHEN** a maintainer compares an explicitly pinned plugin declaration with `lazy-lock.json`
- **THEN** both references identify the same immutable commit

### Requirement: Tested plugin lock refresh
A Neovim plugin-lock refresh SHALL preserve successful clean headless Neovim startup and SHALL not leave a partially synchronized lockfile after a failure.

#### Scenario: Successful lock refresh
- **WHEN** the refreshed configuration and lockfile are applied
- **THEN** `nvim --clean --headless +qa` succeeds and the lockfile remains valid JSON

#### Scenario: Failed plugin synchronization
- **WHEN** plugin synchronization fails during a lock refresh
- **THEN** the repository retains or restores the previously valid lockfile
