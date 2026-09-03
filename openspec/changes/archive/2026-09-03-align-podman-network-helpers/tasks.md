## 1. Review compatibility inputs and migration safety

- [x] 1.1 Confirm the reviewed Podman v6.0.2, Netavark v2.0.0, and Aardvark-DNS v2.0.0 compatibility relationship from authoritative upstream release metadata.
- [x] 1.2 Record immutable release URLs, publisher SHA-256 digests, supported architectures, and the compatibility rationale in `docs/PROVISIONING_INPUTS.md`.
- [x] 1.3 Inspect reverse dependencies for Debian Netavark and Aardvark-DNS packages and define a safe removal or replacement path that does not reset Podman storage.

## 2. Provision verified compatible helpers

- [x] 2.1 Add centralized role inputs for the reviewed Netavark and Aardvark-DNS release artifacts and source-built Podman helper installation location.
- [x] 2.2 Remove distribution Netavark and Aardvark-DNS packages from the Podman role's helper source and configure explicit resolution of the managed helper location.
- [x] 2.3 Implement staged, checksum-verified download, decompression, atomic installation, exact-version verification, unsupported-architecture rejection, and failure cleanup for both helpers.
- [x] 2.4 Preserve existing managed helpers until their replacements pass integrity and version validation; provide actionable failures for unsupported architectures and integrity mismatches.

## 3. Validate the rootless network backend

- [x] 3.1 Add focused role tests for successful compatible-helper provisioning, existing matching helpers, unsupported architectures, artifact checksum mismatch, and cleanup on failure.
- [x] 3.2 Add a rootless lifecycle validation that creates and removes an isolated diagnostic network and proves the active Netavark supports the required network-create protocol.
- [x] 3.3 Run the Podman role's applicable lint and syntax checks, focused provisioning tests, direct rootless network lifecycle test, and the relevant Compose workflow without invoking `podman system reset`.
