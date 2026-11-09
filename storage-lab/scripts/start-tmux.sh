#!/usr/bin/env bash
set -euo pipefail

session="storage-lab"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmux has-session -t "$session" 2>/dev/null && {
  echo "A sessão $session já existe. Entre com: tmux attach -t $session"
  exit 0
}

tmux new-session -d -s "$session" -n monitor -c "$root" "bash scripts/tmux-watch.sh AWS floci-aws http://localhost:4566/_floci/info"
tmux split-window -h -t "$session":0 -c "$root" "bash scripts/tmux-watch.sh Azure floci-az https://localhost:4577/_floci/info"
tmux split-window -v -t "$session":0 -c "$root" "bash scripts/tmux-watch.sh GCP floci-gcp http://localhost:4588/_floci/info"
tmux split-window -v -t "$session":0 -c "$root" "bash scripts/tmux-watch.sh OCI floci-oci http://localhost:4599/_floci/info"
tmux split-window -v -t "$session":0 -c "$root" "bash scripts/docker-stats.sh"
tmux select-layout -t "$session":0 tiled

echo "Painel pronto. Abra com: tmux attach -t $session"
