#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

bash scripts/verify-local-only.sh
bash scripts/preflight.sh
bash scripts/generate-oci-local-key.sh
eval "$(bash scripts/prepare-azure-tls.sh)"
eval "$(bash scripts/prepare-oci-endpoint.sh)"

for cloud in aws azure gcp oci; do
  echo
  echo "===== ${cloud^^}: init, validate e plan ====="
  (
    cd "$cloud"
    terraform init -input=false
    terraform validate
    terraform plan -input=false
  )
done

echo "Plans concluídos. Nenhum apply foi executado."
