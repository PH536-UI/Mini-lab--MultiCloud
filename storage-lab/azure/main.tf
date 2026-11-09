terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_cli       = false
  environment   = "stack"
  metadata_host = "localhost:4577"

  subscription_id = "00000000-0000-0000-0000-000000000001"
  tenant_id       = "00000000-0000-0000-0000-000000000002"
  client_id       = "11111111-1111-1111-1111-111111111111"
  client_secret   = "floci-az-dev-secret"
}

resource "azurerm_resource_group" "storage_lab" {
  name     = "rg-storage-lab-local"
  location = "eastus"
}

resource "azurerm_storage_account" "storage_lab" {
  name                            = "phstoragelablocal"
  resource_group_name             = azurerm_resource_group.storage_lab.name
  location                        = azurerm_resource_group.storage_lab.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "private_blob" {
  name                  = "private-blob"
  storage_account_name  = azurerm_storage_account.storage_lab.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_lab.name
}
