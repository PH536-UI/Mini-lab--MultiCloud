#!/usr/bin/env bash
set -euo pipefail

while true; do
  clear
  date
  docker stats --no-stream floci-aws floci-az floci-gcp floci-oci
  sleep 4
done
