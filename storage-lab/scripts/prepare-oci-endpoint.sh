#!/usr/bin/env bash
set -euo pipefail

# Só redireciona Object Storage ao floci-oci. Nenhum endpoint Oracle real é usado.
printf "%s\n" "export TF_VAR_client_host_overrides='oci_objectstorage.ObjectStorageClient=http://localhost:4599'"
