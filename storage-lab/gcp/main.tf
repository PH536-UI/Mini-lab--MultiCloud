terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project                 = "floci-local"
  region                  = "us-central1"
  access_token            = "floci"
  storage_custom_endpoint = "http://localhost:4588/storage/v1/"
}

resource "google_storage_bucket" "storage_lab" {
  name                        = "ph-storage-lab-gcp-local"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = false
}

output "bucket_name" {
  value = google_storage_bucket.storage_lab.name
}
