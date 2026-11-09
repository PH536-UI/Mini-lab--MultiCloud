#!/usr/bin/env python3
"""Copia evidências de plano para uma pasta compartilhável, mascarando segredos comuns."""
from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
source = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else ROOT / "evidence"
target = Path(sys.argv[2]).resolve() if len(sys.argv) > 2 else ROOT / "evidence-sanitized"

if not source.is_dir():
    raise SystemExit(f"Pasta de evidências não encontrada: {source}")

if target.exists():
    shutil.rmtree(target)
target.mkdir(parents=True)

patterns = [
    (re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----.*?-----END [A-Z ]*PRIVATE KEY-----", re.S), "[REDACTED PRIVATE KEY]"),
    (re.compile(r"(?im)^(\s*(?:client_secret|private_key|access_key|secret_key|token|password)\s*[=:]\s*).*$"), r"\1[REDACTED]"),
    (re.compile(r"(?i)(https?://)[^\s/@:]+:[^\s/@]+@"), r"\1[REDACTED]@"),
]

for item in source.rglob("*"):
    if item.is_dir():
        continue
    relative = item.relative_to(source)
    destination = target / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    try:
        text = item.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue
    for pattern, replacement in patterns:
        text = pattern.sub(replacement, text)
    destination.write_text(text, encoding="utf-8")

print(f"Evidências sanitizadas em: {target}")
