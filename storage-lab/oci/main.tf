terraform {
  required_version = ">= 1.6.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
}

variable "client_host_overrides" {
  description = "Override local do Object Storage no emulador floci-oci."
  type        = string
}

locals {
  tenancy_ocid = "ocid1.tenancy.oc1..flocilocaltenancy0000000000000000000000000000000000000000"
}

provider "oci" {
  tenancy_ocid          = local.tenancy_ocid
  user_ocid             = "ocid1.user.oc1..flocilocaluser0000000000000000000000000000000000000000"
  fingerprint           = "aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99"
  private_key_path      = "${path.module}/.local/oci_api_key.pem"
  region                = "us-ashburn-1"
  client_host_overrides = var.client_host_overrides
}

resource "oci_objectstorage_bucket" "storage_lab" {
  compartment_id        = local.tenancy_ocid
  namespace             = "floci-local"
  name                  = "ph-storage-lab-oci-local"
  access_type           = "NoPublicAccess"
  object_events_enabled = false
}

output "bucket_name" {
  value = oci_objectstorage_bucket.storage_lab.name
}
