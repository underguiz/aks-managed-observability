resource "azurerm_virtual_network" "aks-observability" {
  name                = "aks-observability"
  resource_group_name = data.azurerm_resource_group.aks-observability.name 
  location            = data.azurerm_resource_group.aks-observability.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "app" {
  name                 = "app"
  resource_group_name  = data.azurerm_resource_group.aks-observability.name 
  virtual_network_name = azurerm_virtual_network.aks-observability.name
  address_prefixes     = ["10.254.0.0/22"]
}