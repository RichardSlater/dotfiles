## Quick orientation for AI coding agents

This repository is a personal chezmoi-managed dotfiles collection for Windows (PowerShell/pwsh) and Unix-like shells (zsh, bash). The goal of these instructions is to give a compact, actionable view of the repository so an AI agent can be productive immediately.

- Top-level files named with a `dot_` prefix are chezmoi source files that map to real dotfiles (e.g. `dot_zshrc` -> `~/.zshrc`). Do not rename them; edit the source `dot_` file or its `.tmpl` variant.
- Templates use the `.tmpl` suffix and are processed by chezmoi. Edit templates (for example `dot_config/nvim/init.lua.tmpl` or `dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl`) rather than the rendered output.
- The repo contains platform-specific content: Windows/PowerShell under `AppData/` and `dot_config/powershell`, Linux under `scripts/` (Ansible), and cross-platform config under `dot_config/`.

### Important files and locations (examples)

- `README.md` — install/use examples (chezmoi init/apply, winget example for Windows).
- `scripts/ansible/playbook.yml` — central Ansible playbook used for system/user setup; references many roles (`neovim`, `pwsh`, `oh-my-posh`, `fzf`, `tmux`, etc.). Use it to learn expected packages and role boundaries.
- `scripts/ansible/roles/` — (if present) contains role implementations; changes here affect automated system setup.
- `dot_config/` — config directories (nvim, tmux, powershell, etc.). Templates here are canonical.
- `dot_local/bin` — small helper scripts / symlinks included to be installed into `$HOME/.local/bin`.
- `dot_local/share/fonts/FiraCode/` — bundled fonts (intentional inclusion for local installs).

### Project-specific conventions and patterns

- chezmoi source naming: files start with `dot_` instead of a leading `.`. Respect that mapping.
- `.tmpl` files contain template variables used by chezmoi. When changing behavior, prefer editing `.tmpl` and add/update variables via chezmoi configuration if needed.
- Windows vs Linux branches: many items are arranged so Windows-specific artifacts live under `AppData/` and `dot_config/powershell` while POSIX artifacts live at top-level `dot_*` and under `dot_config/`.
- The repo intentionally keeps some read-only reference copies under `readonly_*` — these are not the source-of-truth for chezmoi but kept for reference.

### Workflows and commands (concrete)

- Preview what chezmoi will change (safe):

```powershell
# Windows (PowerShell)
chezmoi diff
```

```sh
# Linux / WSL
chezmoi diff
```

- Apply changes locally (interactive or one-shot for transient environments):

```powershell
chezmoi init --apply --verbose RichardSlater   # persistent install (Windows)
```

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot RichardSlater  # transient/container
```

- Use the repo's Ansible playbook for system provisioning and examples of expected packages:

```sh
ansible-playbook scripts/ansible/playbook.yml -c local
```

### What to edit vs what to avoid

- Edit source `dot_*` files and `*.tmpl` templates. Examples: `dot_bashrc`, `dot_config/nvim/init.lua.tmpl`.
- Avoid editing rendered/user files on remote machines; those are managed by chezmoi and will be overwritten.
- If you change package lists or provisioning logic, update `scripts/ansible/playbook.yml` and corresponding `roles/` implementations.
- Under no circumstances should unsigned commits be created, if GPG signing fails then defer to the user to resolve.

### Testing and safety

- For risky changes, test in a disposable environment (container, VM, or WSL). Use `chezmoi init --one-shot` to apply to a throwaway environment.
- Use `chezmoi diff` and `chezmoi doctor` (if available) to validate template rendering.

### Integration points / external dependencies

- Uses `chezmoi` (required) and on Windows `winget` for installing the chezmoi client (see `README.md`).
- Ansible roles may rely on external role collections (e.g. `geerlingguy.go`, `alvistack.podman`). Check `scripts/ansible/requirements.yml` for pinned role sources.
- Fonts and binaries are included locally; packaging scripts (Ansible/roles) expect these to be present in `dot_local/` and `dot_local/share`.

### Quick examples to reference in PRs

- Changing Neovim config: edit `dot_config/nvim/init.lua.tmpl` and test with `chezmoi diff`, then `chezmoi apply` in a test profile.
- Adding a new Windows PowerShell prompt element: change `dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl` and test by opening `pwsh` or using `pwsh -NoProfile -Command "& $PROFILE"`.

If anything here is unclear or you need deeper details (template vars, a list of installed ansible roles, or how chezmoi maps `dot_` names to destinations), say which area and I will expand the file.
