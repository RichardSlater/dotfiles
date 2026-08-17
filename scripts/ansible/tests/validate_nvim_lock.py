#!/usr/bin/env python3
"""Validate the explicit immutable Neovim plugin pins against lazy-lock.json."""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
INIT = ROOT / ".chezmoitemplates/nvim/init.lua"
LOCK = ROOT / ".chezmoitemplates/nvim/lazy-lock.json"
text = INIT.read_text(encoding="utf-8")
lock = json.loads(LOCK.read_text(encoding="utf-8"))
pins = {
    "CopilotChat.nvim": "451d365928a994cda3505a84905303f790e28df8",
    "nvim-treesitter": "074aa4422bf029908338e855d0c0f71470a971bb",
    "telescope.nvim": "a0bbec21143c7bc5f8bb02e0005fa0b982edc026",
    "neo-tree.nvim": "ebd66767191714e008ce73b769518a763ff31bdc",
}
errors = []
for plugin, commit in pins.items():
    if commit not in text:
        errors.append(f"{plugin}: declaration does not contain {commit}")
    if lock.get(plugin, {}).get("commit") != commit:
        errors.append(f"{plugin}: lockfile commit does not match {commit}")
if not re.search(r'local lazycommit = "[0-9a-f]{40}"', text):
    errors.append("lazy.nvim bootstrap is not pinned to a full immutable commit")
if errors:
    print("\n".join(errors))
    sys.exit(1)
print("PASS: lazy-lock.json is valid and matches all explicit plugin pins.")
