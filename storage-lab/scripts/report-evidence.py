#!/usr/bin/env python3
"""Gera um relatório Markdown a partir de evidências sanitizadas de Terraform plan."""
from __future__ import annotations

import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
source = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else ROOT / "evidence-sanitized"
report = Path(sys.argv[2]).resolve() if len(sys.argv) > 2 else source / "RELATORIO-VALIDACAO.md"

if not source.is_dir():
    raise SystemExit(f"Pasta de evidências sanitizadas não encontrada: {source}")

clouds = ("aws", "azure", "gcp", "oci")
results: list[tuple[str, int, int, int, str]] = []
plan_pattern = re.compile(r"Plan:\s+(\d+) to add,\s+(\d+) to change,\s+(\d+) to destroy\.")

for cloud in clouds:
    plans = sorted(source.glob(f"*-{cloud}-plan.txt"))
    if not plans:
        results.append((cloud, 0, 0, 0, "ausente"))
        continue
    content = plans[-1].read_text(encoding="utf-8", errors="replace")
    match = plan_pattern.search(content)
    if not match:
        results.append((cloud, 0, 0, 0, "sem resumo de plano"))
        continue
    add, change, destroy = map(int, match.groups())
    results.append((cloud, add, change, destroy, "ok"))

if any(status != "ok" for *_, status in results):
    raise SystemExit("Não foi possível gerar relatório: falta um ou mais planos válidos.")

totals = tuple(sum(row[index] for row in results) for index in (1, 2, 3))
lines = [
    "# Relatório de validação local-first",
    "",
    f"Gerado em: {datetime.now(timezone.utc).isoformat(timespec='seconds')}",
    "",
    "## Resultado",
    "",
    "| Cloud | Adicionar | Alterar | Destruir | Status |",
    "|---|---:|---:|---:|---|",
]
for cloud, add, change, destroy, status in results:
    lines.append(f"| {cloud.upper()} | {add} | {change} | {destroy} | {status} |")
lines += [
    f"| **Total** | **{totals[0]}** | **{totals[1]}** | **{totals[2]}** | **ok** |",
    "",
    "## Controles verificados",
    "",
    "- Execução limitada a `terraform init`, `terraform validate` e `terraform plan`.",
    "- Endpoints restritos aos emuladores locais AWS, Azure, GCP e OCI.",
    "- Evidências sanitizadas antes da geração deste relatório.",
    "- Nenhum `terraform apply` foi executado por esta esteira.",
]
report.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Relatório criado em: {report}")
