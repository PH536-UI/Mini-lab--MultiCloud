#!/usr/bin/env bash
set -euo pipefail

label="$1"
container="$2"
endpoint="$3"

while true; do
  clear
  printf "%s | %s\n\n" "$label" "$(date +%H:%M:%S)"
  printf "Container: "
  docker inspect -f "{{.State.Health.Status}}" "$container" 2>/dev/null || printf "indisponível\n"
  printf "\nEndpoint: %s\n" "$endpoint"
  curl -kfsS --max-time 3 "$endpoint" 2>&1 | head -c 1200 || true
  sleep 4
done
