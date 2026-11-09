#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "BLOQUEADO: $*" >&2
  exit 1
}

require_text() {
  local file="$1"
  local expected="$2"
  grep -Fq "$expected" "$file" || fail "configuração local esperada não encontrada: $file → $expected"
}

# Impede que credenciais do host sejam consideradas durante a demonstração.
real_credential_vars=(
  AWS_PROFILE AWS_SHARED_CREDENTIALS_FILE AWS_SESSION_TOKEN
  ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_SUBSCRIPTION_ID ARM_TENANT_ID
  GOOGLE_APPLICATION_CREDENTIALS GOOGLE_CREDENTIALS
  OCI_CONFIG_FILE OCI_CLI_CONFIG_FILE OCI_CONFIG_PROFILE OCI_CLI_PROFILE
)

for variable in "${real_credential_vars[@]}"; do
  [[ -z "${!variable:-}" ]] || fail "a variável $variable está definida. Remova-a antes de executar o laboratório local."
done

require_text "$root/aws/main.tf" 's3 = "http://localhost:4566"'
require_text "$root/azure/main.tf" 'metadata_host = "localhost:4577"'
require_text "$root/gcp/main.tf" 'storage_custom_endpoint = "http://localhost:4588/storage/v1/"'
require_text "$root/oci/main.tf" 'tenancy_ocid = "ocid1.tenancy.oc1..flocilocal'

# A esteira só permite operações de leitura/validação do Terraform.
for script in "$root/scripts/plan-all.sh" "$root/scripts/collect-evidence.sh"; do
  if grep -Eq '(^|[[:space:]])terraform[[:space:]]+(apply|destroy|import|taint|untaint|state)([[:space:]]|$)' "$script"; then
    fail "operação Terraform mutável encontrada em $(basename "$script")"
  fi
done

echo "Proteção local-first OK: endpoints localhost, sem credenciais do host e sem comandos mutáveis na esteira."
