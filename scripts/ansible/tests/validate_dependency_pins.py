#!/usr/bin/env python3
"""Check offline coupling of release versions, artifact URLs, hashes and Git refs.

Publisher authenticity must be checked separately; see the dated refresh record.
Requires PyYAML, which is also required by Ansible.
"""
from pathlib import Path
import re
import sys

import yaml

ROOT = Path(__file__).resolve().parents[1]
ERRORS = []


def load(path):
    return yaml.safe_load((ROOT / path).read_text(encoding="utf-8"))


def check(condition, message):
    if not condition:
        ERRORS.append(message)


def checksum(value, algorithm, label):
    length = {"sha256": 64, "sha512": 128}[algorithm]
    check(
        isinstance(value, str)
        and re.fullmatch(rf"{algorithm}:[0-9a-f]{{{length}}}", value) is not None,
        f"{label}: expected a full {algorithm} checksum",
    )


def artifact(value, expected_url, algorithm, label):
    check(value["url"] == expected_url, f"{label}: artifact URL/version mismatch")
    checksum(value["checksum"], algorithm, label)


def defaults(role):
    return load(f"roles/{role}/defaults/main.yml")


def main():
    shared = load("group_vars/all.yml")
    check(
        re.fullmatch(r"[0-9a-f]{64}", shared["go_checksum"]) is not None,
        "Go: expected the official archive's full SHA-256",
    )
    for arch, suffix in {"x86_64": "x64", "aarch64": "arm64"}.items():
        version = shared["mise_version"]
        artifact(
            shared["mise_artifacts"][arch],
            f"https://github.com/jdx/mise/releases/download/v{version}/mise-v{version}-linux-{suffix}",
            "sha256",
            f"mise {arch}",
        )

        dotnet = defaults("dotnet")
        version = dotnet["dotnet_sdk_version"]
        artifact(
            dotnet["dotnet_artifacts"][arch],
            f"https://builds.dotnet.microsoft.com/dotnet/Sdk/{version}/dotnet-sdk-{version}-linux-{suffix}.tar.gz",
            "sha512",
            f".NET {arch}",
        )

        oxlint = defaults("oxlint")
        version = oxlint["oxlint_version"]
        binary = f"oxlint-{arch}-unknown-linux-gnu"
        artifact(
            oxlint["oxlint_artifacts"][arch],
            f"https://github.com/oxc-project/oxc/releases/download/oxlint_v{version}/{binary}.tar.gz",
            "sha256",
            f"Oxlint {arch}",
        )
        check(
            oxlint["oxlint_artifacts"][arch]["archive_binary_name"] == binary,
            f"Oxlint {arch}: archive binary mismatch",
        )

    for role, key in [("pwsh", "pwsh_checksums"), ("oh-my-posh", "oh_my_posh_checksums")]:
        values = defaults(role)[key]
        for arch in ["amd64", "arm64"]:
            checksum(values[arch], "sha256", f"{role} {arch}")

    uv = defaults("uv")
    checksum(uv["uv_checksum"], "sha256", "uv")
    check(
        uv["uv_download_url"] == "https://github.com/astral-sh/uv/releases/download/{{ uv_version }}/uv-{{ uv_platform }}.tar.gz",
        "uv: URL must follow the configured version and platform",
    )
    checksum(defaults("tmux")["tmux_checksum"], "sha256", "tmux")
    copilot = defaults("copilot_cli")
    version = copilot["copilot_cli_version"]
    check(
        copilot["copilot_cli_tarball_url"] == f"https://registry.npmjs.org/@github/copilot/-/copilot-{version}.tgz",
        "Copilot: tarball URL/version mismatch",
    )
    checksum(copilot["copilot_cli_tarball_checksum"], "sha512", "Copilot")

    for role, path, key in [
        ("gh", "defaults", "gh_version"),
        ("fzf", "vars", "fzf_version"),
        ("neovim", "vars", "neovim_version"),
        ("podman", "defaults", "podman_ref"),
    ]:
        values = load(f"roles/{role}/{path}/main.yml")
        check(
            re.fullmatch(r"[0-9a-f]{40}", values[key]) is not None,
            f"{role}: expected a full immutable commit",
        )
        if role == "neovim":
            check(values[key] == values["neovim_ref"], "Neovim: source refs disagree")

    podman_tasks = load("roles/podman/tasks/main.yml")
    clone = next(task for task in podman_tasks if task["name"] == "Clone Podman repository")
    check(clone["git"]["version"] == "{{ podman_ref }}", "Podman: checkout must use the immutable ref")

    if ERRORS:
        print("\n".join(ERRORS))
        return 1
    print("PASS: dependency artifact URLs, checksum formats and immutable refs are consistent.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
