#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
key_dir="$root/oci/.local"
key_path="$key_dir/oci_api_key.pem"
mkdir -p "$key_dir"

if [[ ! -f "$key_path" ]]; then
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$key_path" >/dev/null 2>&1
fi
chmod 600 "$key_path"
printf "Chave temporária OCI pronta em %s\n" "$key_path"
