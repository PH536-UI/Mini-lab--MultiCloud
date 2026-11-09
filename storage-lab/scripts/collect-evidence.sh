#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
evidence_dir="$root/evidence"
timestamp="$(date +%Y%m%d-%H%M%S)"

bash "$root/scripts/verify-local-only.sh"
mkdir -p "$evidence_dir"

{
  echo "# Evidências locais do onboarding multicloud"
  echo
  echo "Gerado em: $(date --iso-8601=seconds)"
  echo "Escopo: apenas preflight, init, validate e plan. Nenhum apply foi executado."
  echo
  echo "## Saúde dos emuladores"
  docker compose -f "$root/../compose.yaml" ps
  docker inspect -f '{{.Name}} {{.State.Health.Status}}' floci-aws floci-az floci-gcp floci-oci
} > "$evidence_dir/${timestamp}-health.md"

bash "$root/scripts/preflight.sh" | tee "$evidence_dir/${timestamp}-preflight.txt"
bash "$root/scripts/generate-oci-local-key.sh" | tee "$evidence_dir/${timestamp}-oci-key.txt"
eval "$(bash "$root/scripts/prepare-azure-tls.sh")"
eval "$(bash "$root/scripts/prepare-oci-endpoint.sh")"

for cloud in aws azure gcp oci; do
  (
    cd "$root/$cloud"
    terraform init -input=false
    terraform validate
    terraform plan -input=false
  ) | tee "$evidence_dir/${timestamp}-${cloud}-plan.txt"
done

printf "Evidências gravadas em: %s\n" "$evidence_dir"
