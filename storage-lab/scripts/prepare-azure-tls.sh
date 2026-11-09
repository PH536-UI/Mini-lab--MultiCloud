#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cert_dir="$root/azure/.local"
cert_path="$cert_dir/floci-az-ca.crt"
mkdir -p "$cert_dir"

curl -kfsS https://localhost:4577/_floci/tls-cert -o "$cert_path"
chmod 600 "$cert_path"
printf "export SSL_CERT_FILE=%q\n" "$cert_path"
