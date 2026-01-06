# Dotfiles for Powershell on Windows (pwsh) and Zsh

## Repository Index

This repository manages a full developer environment across Windows and Linux.

### Ansible Roles (Linux/WSL)
| Role | Description | Source |
| :--- | :--- | :--- |
| [packages](scripts/ansible/roles/packages) | Common system utilities (jq, ripgrep, btop, etc.) | [scripts/ansible/playbook.yml](scripts/ansible/playbook.yml) |
| [podman](scripts/ansible/roles/podman) | Rootless container engine (built from source) | [scripts/ansible/roles/podman/tasks/main.yml](scripts/ansible/roles/podman/tasks/main.yml) |
| [neovim](scripts/ansible/roles/neovim) | Modern editor built from source with C# support | [scripts/ansible/roles/neovim/tasks/main.yml](scripts/ansible/roles/neovim/tasks/main.yml) |
| [gh](scripts/ansible/roles/gh) | GitHub CLI (built from source) | [scripts/ansible/roles/gh/tasks/main.yml](scripts/ansible/roles/gh/tasks/main.yml) |
| [uv](scripts/ansible/roles/uv) | Astral's fast Python package manager | [scripts/ansible/roles/uv/tasks/main.yml](scripts/ansible/roles/uv/tasks/main.yml) |
| [cargo](scripts/ansible/roles/cargo) | Rust toolchain & tools (e.g. tree-sitter) | [scripts/ansible/roles/cargo/tasks/main.yml](scripts/ansible/roles/cargo/tasks/main.yml) |
| [zsh](scripts/ansible/roles/zsh) | Shell configuration with Oh-My-Zsh | [scripts/ansible/roles/zsh/tasks/main.yml](scripts/ansible/roles/zsh/tasks/main.yml) |
| [tmux](scripts/ansible/roles/tmux) | Terminal multiplexer with custom config | [scripts/ansible/roles/tmux/tasks/main.yml](scripts/ansible/roles/tmux/tasks/main.yml) |
| [oh-my-posh](scripts/ansible/roles/oh-my-posh) | Cross-shell prompt theme engine | [scripts/ansible/roles/oh-my-posh/tasks/main.yml](scripts/ansible/roles/oh-my-posh/tasks/main.yml) |
| [fzf](scripts/ansible/roles/fzf) | Command-line fuzzy finder | [scripts/ansible/roles/fzf/tasks/main.yml](scripts/ansible/roles/fzf/tasks/main.yml) |

### Key Features
- **Neovim**: C# (Roslyn) support via [roslyn.nvim](https://github.com/seblyng/roslyn.nvim), LazyVim integration.
- **Rootless Podman**: Fully configured rootless containerization on Debian/Ubuntu.
- **Cross-Platform Prompt**: Unified look via [dot_config/oh-my-posh](dot_config/oh-my-posh).
- **Modern CLI Tools**: Up-to-date versions of [scripts/ansible/roles/bat](scripts/ansible/roles/bat), [scripts/ansible/roles/fzf](scripts/ansible/roles/fzf), [scripts/ansible/roles/gh](scripts/ansible/roles/gh), [scripts/ansible/roles/uv](scripts/ansible/roles/uv), and [scripts/ansible/roles/speckit](scripts/ansible/roles/speckit).

## Windows Install

```powershell
winget install twpayne.chezmoi
chezmoi init --apply --verbose RichardSlater
```

## Linux Install

```sh
sudo apt update && sudo apt install --yes curl git unzip
curl -s https://ohmyposh.dev/install.sh | bash -s
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply RichardSlater
```

### Configure SSH Push/Pull URL

```sh
chezmoi cd
git remote set-url --no-push origin https://github.com/richardslater/dotfiles.git
git remote set-url --push origin git@github.com:RichardSlater/dotfiles.git
```

## Transient Install

This is used only for transient environments like containers:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot RichardSlater
```

## Neovim: C# (Roslyn)

This repo enables [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) for C# buffers.

- Install a Roslyn Language Server executable on your PATH (config prefers roslyn, but will also use Microsoft.CodeAnalysis.LanguageServer if found).
- Ensure a recent .NET SDK is installed.

Verify prerequisites on Windows:

```powershell
dotnet --info
Get-Command roslyn -ErrorAction SilentlyContinue
Get-Command Microsoft.CodeAnalysis.LanguageServer -ErrorAction SilentlyContinue
```
