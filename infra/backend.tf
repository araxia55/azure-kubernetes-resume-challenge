terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-webapp-resource-group"
    storage_account_name = "tfbackendstorage5555"
    container_name       = "backend-tfstate"
    key                  = "backend-tfstate-file"
  }
}