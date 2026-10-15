# Ansible dependency refresh — 2026-10-15

Versions were resolved from publisher-controlled HTTPS metadata on 2026-10-15.
Only stable releases were selected: GitHub releases marked `prerelease: false`,
npm's `latest` tag, Microsoft's stable .NET 10 SDK, and Node's latest Current
release. Node 26 Current is intentionally selected rather than Node 24 LTS.
Role variables remain the operational source of truth for URLs and full hashes.

## Release selection and integrity sources

For GitHub assets, the linked release API's `assets[].digest` is the publisher
checksum source. Each of the 14 updated direct-download artifacts was also
streamed independently from its configured official URL and hashed locally;
all matched. No downloaded executable or installer was run during verification.

| Component | Selected version | Authoritative metadata | Verification |
| --- | --- | --- | --- |
| Go | 1.27.2 | [Official download manifest](https://go.dev/dl/?mode=json) | `go1.27.2.linux-amd64.tar.gz` publisher SHA-256; downloaded and matched |
| mise | 2026.10.11 | [Release API](https://api.github.com/repos/jdx/mise/releases/tags/v2026.10.11) | Linux x64 and arm64 asset SHA-256; both downloaded and matched |
| Oh My Posh | 31.8.0 | [Release API](https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/tags/v31.8.0) | `posh-linux-amd64` and `posh-linux-arm64` SHA-256; both downloaded and matched |
| Oxlint | 1.88.0 | [Release API](https://api.github.com/repos/oxc-project/oxc/releases/tags/oxlint_v1.88.0) | Linux GNU x86_64 and aarch64 tarball SHA-256; both downloaded and matched |
| PowerShell | 7.6.7 | [Release API](https://api.github.com/repos/PowerShell/PowerShell/releases/tags/v7.6.7) | `powershell_7.6.7-1.deb_{amd64,arm64}.deb` SHA-256; both downloaded and matched (not the separate `powershell-lts` packages) |
| tmux | 3.8 | [Release API](https://api.github.com/repos/tmux/tmux/releases/tags/3.8) | `tmux-3.8.tar.gz` SHA-256; downloaded and matched |
| uv | 0.13.1 | [Release API](https://api.github.com/repos/astral-sh/uv/releases/tags/0.13.1) | `uv-x86_64-unknown-linux-gnu.tar.gz` SHA-256; downloaded and matched |
| .NET SDK | 10.0.402 | [Microsoft release manifest](https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/10.0/releases.json) | Exact SDK Linux x64 and arm64 archive SHA-512 from `sdks[].files[].hash`; both downloaded and matched. .NET 11 RC excluded |
| GitHub Copilot CLI | 1.0.98 | [Exact npm package metadata](https://registry.npmjs.org/@github%2fcopilot/1.0.98) | `dist.integrity` SHA-512 decoded from base64 to Ansible's hexadecimal form; official npm tarball downloaded and matched |
| Node.js | 26.12.0 | [Release index](https://nodejs.org/dist/index.json), [exact checksum manifest](https://nodejs.org/dist/v26.12.0/SHASUMS256.txt) | nvm validates upstream archive checksums at installation; no new repository-owned Node archive hash is introduced |
| pnpm | 12.11.2 | [Exact npm package metadata](https://registry.npmjs.org/pnpm/12.11.2) | Stable version selection only; existing installer integrity exception retained below |
| community.general | 13.5.0 | [Exact Galaxy metadata](https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/index/community/general/versions/13.5.0/) | Publisher artifact SHA-256 `54598287e0ea0504aee2d32c884208ddf26f3ac41e0b4e773ff514af210787c4`; requires ansible-core `>=2.18.0`. Artifact download was blocked by a connection reset, so this is metadata evidence, not a local download-verification claim |

## Immutable Git source pins

Tag targets were resolved through the official GitHub Git References API,
following annotated tag objects to their commit. GitHub's tag verification
reported `verified: true`, reason `valid`, for fzf, Neovim, and Podman. GitHub CLI
uses a lightweight tag, so no signed-tag claim is made for it.

| Component | Official release reference | Immutable commit |
| --- | --- | --- |
| GitHub CLI 2.102.0 | [Tag ref API](https://api.github.com/repos/cli/cli/git/ref/tags/v2.102.0) | `fc4b137cdef0a6bd28fd461b7cf9c84a5812a8cd` |
| fzf 0.74.5 | [Tag ref API](https://api.github.com/repos/junegunn/fzf/git/ref/tags/v0.74.5) | `c0a193e031f01fb50bf6f7be4381990a3753f7cf` |
| Neovim 0.12.6 | [Tag ref API](https://api.github.com/repos/neovim/neovim/git/ref/tags/v0.12.6) | `779c36969e31080503be2dfccbcc3f999e289606` |
| Podman 6.1.4 | [Tag ref API](https://api.github.com/repos/podman-container-tools/podman/git/ref/tags/v6.1.4) | `464c15fec06f0074c916f9eff87c4806869c2833` |

Podman now checks out `podman_ref`, not the mutable release tag. Overrides must
update both its display/runtime version and source commit. Its existing
Netavark/Aardvark-DNS 2.1.0 and containers/image commit remain unchanged.

## Unchanged inputs and bounded exceptions

- Dive, nvm, Netavark, Aardvark-DNS, containers/image, `geerlingguy.go`,
  `hurricanehrndz.rustup`, and `ansible.posix` were already at the latest stable
  versions identified in the preceding review; their version/hash pairs are
  unchanged.
- pnpm's `https://get.pnpm.io/install.sh` is not checksum-verified. Updating
  `PNPM_VERSION` does not authenticate the installer or its downloads. This
  existing exception is not represented as a verified artifact pin.
- Node's archive checksums are nvm-managed, not hard-coded in these role defaults.
- Galaxy requirements remain version pins, not repository-enforced artifact
  checksums. The publisher hash above records evidence without claiming that
  `requirements.yml` enforces it.
- Bun, SpecKit, Antigravity CLI, Rust/Cargo tools, and uv-installed tools retain
  their existing unpinned installation strategies; distribution packages remain
  repository-managed. Converting these mechanisms to reproducible pinned
  installations is outside this version/hash refresh.
- No Neovim plugin pins, CI action versions, or unrelated tooling pins changed.

## Rechecking

Use the exact metadata links above rather than assuming a moving `latest`
endpoint still describes this snapshot. Compare publisher digests with the
configured role hashes and independently hash the downloaded artifact. For Git
pins, dereference annotated tags and compare the full commit ID. Run
`python3 scripts/ansible/tests/validate_dependency_pins.py` for offline version,
URL, checksum-format, and immutable-ref consistency checks; that check is not a
substitute for publisher verification.
