#!/usr/bin/env bash
set -euo pipefail

for command in docker terraform curl openssl; do
  command -v "$command" >/dev/null || { echo "Falta instalar: $command" >&2; exit 1; }
done

for container in floci-aws floci-az floci-gcp floci-oci; do
  status="$(docker inspect -f "{{.State.Health.Status}}" "$container" 2>/dev/null || true)"
  [[ "$status" == "healthy" ]] || { echo "$container não está healthy (estado: ${status:-ausente})" >&2; exit 1; }
done

if ! curl -kfsS https://localhost:4577/_floci/tls-cert >/dev/null; then
  echo "O Azure local ainda não está com TLS. Rode: docker compose up -d --force-recreate floci-az" >&2
  exit 1
fi

echo "Pré-requisitos OK: 4 emuladores saudáveis e TLS Azure ativo."
