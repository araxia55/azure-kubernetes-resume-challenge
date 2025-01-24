provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "backend_webapp" {
  name     = "tf-backend-webapp-resource-group"
  location = "East US"
}

resource "azurerm_storage_account" "backend_webapp" {
  name                     = "tfbackendstorage5555"
  resource_group_name      = azurerm_resource_group.backend_webapp.name
  location                 = azurerm_resource_group.backend_webapp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend_webapp" {
  name                  = "backend-tfstate"
  storage_account_id    = azurerm_storage_account.backend_webapp.id
  container_access_type = "private"
}