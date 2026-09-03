#!/usr/bin/env python3
"""Focused static checks for Podman network-helper provisioning safeguards."""
from pathlib import Path
import unittest

ROLE = Path(__file__).resolve().parents[1] / "roles" / "podman"
DEFAULTS = (ROLE / "defaults" / "main.yml").read_text(encoding="utf-8")
TASKS = (ROLE / "tasks" / "main.yml").read_text(encoding="utf-8")


class PodmanNetworkHelperProvisioningTests(unittest.TestCase):
    def test_successful_compatible_helper_provisioning(self) -> None:
        self.assertIn('netavark:\n      version: "2.0.0"', DEFAULTS)
        self.assertIn('aardvark-dns:\n      version: "2.0.0"', DEFAULTS)
        self.assertIn('dest: "{{ podman_network_helper_stage.path }}/{{ item.key }}.gz"', TASKS)
        self.assertIn('- "{{ podman_network_helper_directory }}/{{ item.key }}"', TASKS)
        self.assertIn("Download verified Podman network helper artifacts", TASKS)
        self.assertIn("Decompress verified Podman network helper artifacts", TASKS)
        self.assertIn("Verify installed Podman network helper versions", TASKS)

    def test_existing_matching_helpers_are_preserved_until_validation(self) -> None:
        preserve = TASKS.index("Preserve existing managed Podman network helpers")
        stage = TASKS.index("Stage validated Podman network helper replacements")
        install = TASKS.index("Atomically install validated Podman network helper replacements")
        self.assertLess(preserve, stage)
        self.assertLess(stage, install)
        self.assertIn(".previous", TASKS)
        self.assertIn("Restore previously managed Podman network helpers", TASKS)

    def test_unsupported_architecture_fails_before_download(self) -> None:
        reject = TASKS.index("Reject unsupported Podman helper architecture")
        download = TASKS.index("Download verified Podman network helper artifacts")
        self.assertLess(reject, download)
        self.assertIn("refusing {{ ansible_architecture }} before download or replacement", TASKS)

    def test_artifact_checksum_mismatch_is_rejected(self) -> None:
        self.assertIn('checksum: "{{ item.value.checksum }}"', TASKS)
        self.assertIn("d8bc342c38382029e7e12256120ac0f7676dcc063aa1e7259189bb69cc869563", DEFAULTS)
        self.assertIn("fdaa3665ce58337fe597e0822e24de97528529d1a39fa6b655aa656c8ad33086", DEFAULTS)

    def test_failure_cleanup_removes_staging_and_keeps_existing_helpers(self) -> None:
        self.assertIn("always:\n    - name: Remove Podman network-helper staging directory", TASKS)
        self.assertIn("Existing managed helpers\n          were preserved or restored", TASKS)
        self.assertIn("Debian helper packages were not removed", TASKS)


if __name__ == "__main__":
    unittest.main()
