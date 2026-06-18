## Plan: Chezmoi And Ansible Architecture Hardening

This plan improves the repository architecture without changing its core operating model: Chezmoi remains the source of truth for user dotfiles and templates, while Ansible remains responsible for provisioning packages, binaries, system services, and system-level configuration. The recommended path is to first document and encode conventions, then fix idempotence and variable drift, then strengthen validation so lower-cost implementation passes can make changes safely.

**Scope Boundaries**

- Included: repository architecture, Chezmoi source layout, Ansible role conventions, idempotence, validation, documentation, and handoff guardrails.
- Included: cleanup of orphaned/dead role artifacts where confirmed unused.
- Excluded: replacing Chezmoi or Ansible, moving dotfile management into Ansible, introducing a different provisioning framework, or broad behavior changes unrelated to maintainability.
- Principle: Ansible must not patch files under the user's home dotfiles; any dotfile behavior change must be made in the Chezmoi source tree.

**Phase 0: Baseline Inventory And Safety Snapshot**

1. Capture the current architecture in a short inventory before editing: Chezmoi source categories, Ansible play sequence, role list, external Galaxy roles, validation tasks, and known platform assumptions.
2. Record intentional invariants in the inventory: Chezmoi owns dotfiles; Ansible owns provisioning; Windows-specific sources live under `AppData/`; Linux user config lives under `dot_*`, `dot_config/`, and `dot_local/`; system setup lives in `scripts/ansible/`.
3. Confirm whether `readonly_Documents/` and `readonly_Pictures/` are intentionally managed reference files or stale compatibility paths. Do not delete them until this is confirmed.
4. Confirm whether shell startup should continue running `chezmoi update` and `chezmoi apply` automatically from `dot_zshrc`. Preserve current behavior unless the user explicitly approves changing it.
5. Verify baseline commands before subsequent phases: Chezmoi dry run, Ansible syntax check, ShellCheck task, and CI-equivalent lint commands.

**Phase 1: Architecture Documentation And Guardrails**

1. Create `docs/ARCHITECTURE.md` describing the Chezmoi/Ansible split, source naming, platform-specific paths, private/readonly prefixes, template delegation rules, and the rule that Ansible must not modify dotfiles.
2. Create `docs/CHEZMOI_VARIABLES.md` documenting `.chezmoi.os`, `.chezmoi.username`, `.chezmoi.kernel.osrelease`, `.chezmoi.osRelease.id`, and repository data keys such as `email` and `role` from `.chezmoi.toml.tmpl`.
3. Create `scripts/ansible/README.md` describing play ordering, role categories, privilege boundaries, external Galaxy dependencies, and which roles are system vs user setup.
4. Add or update `README.md` to link to the new architecture and Ansible docs without duplicating them.
5. Add an implementation checklist for future agents: edit Chezmoi source files for dotfiles, edit role defaults/group vars for provisioning data, run the phase verification commands, and do not create unsigned commits.
6. This phase blocks all later phases because it defines the conventions lower-cost models should follow.

**Phase 2: Chezmoi Layout Clarification And Template Hygiene**

1. Document the `.chezmoitemplates/` delegation pattern: large shared configs go in `.chezmoitemplates/`; platform-specific Chezmoi source files may delegate to them; small platform-specific templates can remain inline.
2. Keep both `dot_config/nvim/init.lua.tmpl` and `AppData/Local/nvim/init.lua.tmpl` as thin delegates if both Linux and Windows layouts are still required; clarify in docs that `.chezmoitemplates/nvim/init.lua` is canonical.
3. Keep both PowerShell delegate paths only if both are intentional; otherwise mark `readonly_Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl` for a separate cleanup decision after confirmation.
4. Refactor `dot_config/windows_aliases.tmpl` only after documenting the desired WSL user path behavior. Preferred direction: derive candidate Windows user paths from Chezmoi data or a small list in `.chezmoi.toml.tmpl`, rather than hard-coding `scetrov` or `mcp` in the template body.
5. Document shell sourcing order for `dot_profile`, `dot_bashrc`, `dot_zshrc`, `dot_config/shell_common`, `dot_config/zsh_aliases`, and `dot_config/windows_aliases.tmpl`.
6. Review duplicate sourcing of `windows_aliases` from both `dot_zshrc` and `dot_config/zsh_aliases`; choose one source point and document the override order before changing behavior.
7. Defer any shell behavior changes until the documentation and validation gates from Phase 1 are in place.

**Phase 3: Ansible Variable Architecture**

1. Create `scripts/ansible/group_vars/all.yml` for repository-level provisioning inputs currently embedded in `scripts/ansible/playbook.yml`, including package lists, unlisted `.deb` packages, `uv_tools`, and external role variables such as Go settings where overrideable.
2. Move user-overridable role settings into `defaults/main.yml`; keep internal constants in `vars/main.yml`. Apply this consistently across roles.
3. Document each role variable in the role README or in a generated-style variable table. Focus first on roles with install versions or paths: `uv`, `copilot-cli`, `antigravity-cli`, `oh-my-posh`, `pwsh`, `gh`, `podman`, `tmux`, `nvm`, `dotnet`, and `cargo`.
4. Decide and document a version strategy: pinned with checksum, pinned without checksum, latest installer, or source build from tag. Each role should state which model it uses and why.
5. Add optional inventory/group var profile guidance only after `all.yml` is stable. Avoid overbuilding profile support in the first pass.
6. This phase depends on Phase 1 and can run in parallel with Phase 2 after the architecture docs exist.

**Phase 4: Ansible Role Cleanup And Idempotence Hardening**

1. Remove the empty/orphaned `scripts/ansible/roles/gemini-cli/` directory if it still exists and is confirmed unused; the current replacement is `antigravity-cli`.
2. Remove or wire the unused `scripts/ansible/roles/oh-my-posh/handlers/main.yml` restart handler. Preferred direction: remove it unless a task genuinely needs it.
3. Fix `scripts/ansible/roles/uv/tasks/main.yml` so uv tool installation does not use `--force` unnecessarily and only reports changed when a tool is newly installed or intentionally updated.
4. Fix `scripts/ansible/roles/speckit/tasks/main.yml` to avoid shelling to `grep`; gather `uv tool list` output and use Ansible conditions for detection.
5. Fix `scripts/ansible/roles/copilot-cli/tasks/main.yml` so `latest` has deterministic behavior. Preferred direction: treat `latest` as install-if-missing unless an explicit update flag is set, and compare exact versions only when a concrete version is configured.
6. Review `scripts/ansible/roles/cargo/tasks/main.yml` changed reporting and update strategy; avoid false no-change reports when `cargo install` actually updates a binary.
7. Replace broad `ignore_errors: true` with `failed_when: false` or explicit rescue handling where the failure is expected, especially check tasks. Keep `ignore_errors` only where documented.
8. This phase depends on Phase 3 for variable placement where touched roles need variable cleanup.

**Phase 5: Shared Role Patterns And Preflight Checks**

1. Create `scripts/ansible/roles/_template/` or `docs/ANSIBLE_ROLE_TEMPLATE.md` with the preferred role structure: defaults, vars, tasks, meta, README, version check, install, verify, cleanup, idempotence notes, and platform gates.
2. Add a lightweight preflight role or preflight play that verifies supported OS family, required package manager, disk space for source builds, and essential commands such as `git`, `curl`, and a working Python interpreter.
3. Standardize architecture mapping for roles that download architecture-specific binaries. Preferred direction: common variables in group vars or a small documented pattern, not a complex abstraction.
4. Standardize build-from-source role shape for `neovim`, `tmux`, `gh`, `podman`, and `fzf`: dependency install, clone/update, build cache path, cleanup policy, version verification, and retry strategy.
5. Keep this phase conservative: avoid custom Ansible plugins unless repeated task files become clearly simpler than local role logic.
6. This phase depends on Phase 4 for role behavior cleanup.

**Phase 6: Validation And CI Hardening**

1. Update `.vscode/test-dotfiles.sh` to use stricter shell options where safe, install only required dependencies, and fail clearly on real Chezmoi template/render errors rather than masking all failures with `|| true`.
2. Add a Docker idempotence test task that runs the Ansible playbook twice in the same container and checks the second run for unexpected changes or failures.
3. Add Ansible syntax and idempotence coverage to CI. Keep full source-build apply optional or scheduled if runtime is too high.
4. Remove `continue-on-error: true` from the CI Ansible lint job only after the lint baseline is addressed or explicitly configured in `.ansible-lint.yml`.
5. Expand Chezmoi validation to render multiple contexts: default Linux, WSL-like Linux, Windows where feasible, and at least the known usernames/roles that drive `.chezmoi.toml.tmpl` behavior.
6. Expand ShellCheck coverage to include `scripts/debian/*.sh`, `scripts/ansible/*.sh`, `dot_profile`, `dot_bashrc`, and `dot_config/shell_common`. Handle zsh-specific files separately to avoid false positives.
7. This phase depends on Phases 1 through 4 for stable conventions and fewer expected failures.

**Phase 7: Optional Cleanup And Simplification**

1. After confirmation, remove stale readonly/reference paths or add clear documentation explaining why they remain.
2. Review `dot_local/bin/symlink_*` WSL helper symlinks and document their target assumptions. Keep them if they are still needed for Windows OpenSSH/GPG integration.
3. Review automatic Chezmoi update/apply from `dot_zshrc`; if approved, gate it behind an explicit environment variable or documented opt-in to reduce shell startup side effects.
4. Consider consolidating repeated container aliases across shell and PowerShell once shell sourcing order is documented and tested.
5. Consider role-level changelogs only for roles with frequent external version updates; avoid adding maintenance burden everywhere.
6. This phase is intentionally optional and should not block the core architecture hardening.

**Relevant Files**

- `README.md` — link to architecture and role docs; keep installation guidance concise.
- `.chezmoi.toml.tmpl` — document and possibly extend data keys for users, roles, and WSL/Windows alias path candidates.
- `.chezmoiignore` — document platform filtering and WSL detection assumptions.
- `.chezmoitemplates/nvim/init.lua` — canonical Neovim config template reused by platform delegates.
- `.chezmoitemplates/pwsh/Microsoft.PowerShell_profile.ps1` — canonical PowerShell profile template reused by platform delegates.
- `dot_config/nvim/init.lua.tmpl` and `AppData/Local/nvim/init.lua.tmpl` — thin platform-specific delegates to the canonical Neovim template.
- `dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl` and `readonly_Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl` — PowerShell delegate paths requiring confirmation/documentation.
- `dot_profile`, `dot_bashrc`, `dot_zshrc`, `dot_config/shell_common`, `dot_config/zsh_aliases`, `dot_config/windows_aliases.tmpl` — shell sourcing and alias architecture.
- `scripts/ansible/playbook.yml` — play ordering and removal of embedded configuration values.
- `scripts/ansible/group_vars/all.yml` — new central provisioning configuration file.
- `scripts/ansible/inventory/hosts.yml` — keep local inventory simple; document how group vars are loaded.
- `scripts/ansible/requirements.yml` — external Galaxy dependencies and version pins.
- `scripts/ansible/private_executable_exec.sh` — bootstrap script for installing Ansible requirements and running the playbook.
- `scripts/ansible/roles/*/{defaults,vars,tasks,meta,README.md}` — role convention standardization.
- `.pre-commit-config.yaml`, `.github/workflows/ci.yml`, `.vscode/tasks.json`, `.vscode/test-dotfiles.sh`, `.yamllint` — local and CI validation architecture.

**Verification Gates**

1. After Phase 1: confirm docs link correctly and run markdown/link checks if available; run existing Chezmoi dry-run task to ensure docs did not disturb source layout.
2. After Phase 2: run `chezmoi execute-template` for edited `.tmpl` files, `chezmoi diff --source=. --verbose`, and the Docker dry-run task.
3. After Phase 3: run `cd scripts/ansible && ansible-galaxy install -r requirements.yml && ansible-playbook playbook.yml --syntax-check` and confirm variable resolution still works.
4. After Phase 4: run targeted role syntax checks and a Docker Ansible apply where practical; re-run affected roles twice to confirm idempotence.
5. After Phase 5: run preflight role/play in Docker on Debian and Ubuntu images; confirm failures are clear on unsupported or missing prerequisites.
6. After Phase 6: run pre-commit, ShellCheck, yamllint, Ansible lint, Chezmoi validation, Ansible syntax check, and the new idempotence test.
7. Before final merge: run the existing VS Code tasks for Chezmoi dry run, Ansible syntax check, and shell lint; run full Ansible apply only when time/network constraints permit.

**Recommended Implementation Order**

1. Phase 0 and Phase 1 first; they reduce ambiguity before code movement.
2. Phase 2 and Phase 3 can proceed in parallel once the architecture docs are in place.
3. Phase 4 should be split into small role-focused PRs or commits: uv/speckit, copilot/antigravity, cargo, cleanup/dead code.
4. Phase 5 should follow the role fixes so the template reflects proven patterns.
5. Phase 6 should become the enforcement layer after the repository is close to clean.
6. Phase 7 should only proceed with explicit user confirmation for behavior-changing cleanup.

**Decisions Captured**

- Keep Chezmoi and Ansible as the fundamental architecture.
- Keep Chezmoi as the only owner of dotfiles and user configuration source files.
- Keep Ansible focused on provisioning, binaries, system configuration, and system dependencies.
- Prefer documentation and convention enforcement before larger refactors.
- Prefer simple Ansible-native patterns over custom plugins unless repetition becomes materially harmful.
- Treat deletion of readonly/reference paths and shell auto-update behavior as explicit confirmation items, not automatic cleanup.
