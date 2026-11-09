#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$root/scripts/verify-local-only.sh"
bash "$root/scripts/collect-evidence.sh"
python3 "$root/scripts/sanitize-evidence.py" "$root/evidence" "$root/evidence-sanitized"
python3 "$root/scripts/report-evidence.py" "$root/evidence-sanitized"

echo "Esteira concluída: planos locais, evidências sanitizadas e relatório final gerados."
