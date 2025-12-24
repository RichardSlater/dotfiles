# Dotfiles for Powershell on Windows (pwsh) and Zsh

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

This repo enables `seblyng/roslyn.nvim` for C# buffers.

- Install a Roslyn Language Server executable on your `PATH` (config prefers `roslyn`, but will also use `Microsoft.CodeAnalysis.LanguageServer` if found).
- Ensure a recent .NET SDK is installed.

Verify prerequisites on Windows:

```powershell
dotnet --info
Get-Command roslyn -ErrorAction SilentlyContinue
Get-Command Microsoft.CodeAnalysis.LanguageServer -ErrorAction SilentlyContinue
```
