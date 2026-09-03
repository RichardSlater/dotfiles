# mise

Installs [mise](https://mise.jdx.dev/) as a user-local toolchain manager from a
pinned GitHub release artifact. The role verifies the publisher-provided
SHA-256 digest before placing the binary in `~/.local/bin`.

## Inputs

Release identity and reviewed architecture artifacts are shared provisioning
inputs in `group_vars/all.yml`:

- `mise_version`
- `mise_install_dir`
- `mise_artifacts`

The role exposes `mise_binary_name` and the derived `mise_binary_path` in
`defaults/main.yml`. Hosts not present in `mise_artifacts` fail before any
download or installation work.

## Verification

The role skips the download when the installed binary reports the configured
version, and always verifies the final installed version.

Shell activation belongs to the Chezmoi-managed `dot_bashrc` and `dot_zshrc`
sources; this role does not modify rendered dotfiles.
