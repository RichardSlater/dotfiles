# Dotfiles for Powershell on Windows (pwsh) and Zsh

## Windows Install

```powershell
winget install twpayne.chezmoi
chezmoi init --apply --verbose RichardSlater
```

## Linux Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply RichardSlater
```

## Transient Install

This is used only for transient environments like containers:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot RichardSlater
```