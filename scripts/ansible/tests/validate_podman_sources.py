#!/usr/bin/env python3
"""Reject mutable GitHub branch URLs in managed Podman configuration sources."""
from pathlib import Path
import re
import sys

ROLE = Path(__file__).resolve().parents[1] / "roles" / "podman"
text = "\n".join(path.read_text(encoding="utf-8") for path in ROLE.rglob("*.yml"))
mutable = re.findall(r"https://raw\.githubusercontent\.com/[^\s/'\"]+?/[^\s/'\"]+?/(?:main|master|stable|HEAD)/", text)
if mutable:
    print("Mutable managed Podman source URL(s) found:", *mutable, sep="\n")
    sys.exit(1)
if "podman_container_image_commit" not in text:
    print("Podman tasks do not reference the reviewed immutable source variable.")
    sys.exit(1)
print("PASS: managed Podman configuration sources do not use mutable branch URLs.")
