#!/usr/bin/env bash
set -euo pipefail

# Direciona os clientes OCI usados pelo provider ao floci-oci local.
printf "%s\n" "export TF_VAR_CLIENT_HOST_OVERRIDES=\"oci_identity.IdentityClient=http://localhost:4599;oci_object_storage.ObjectStorageClient=http://localhost:4599\""
