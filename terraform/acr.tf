resource "random_string" "acr" {
  length           = 6
  special          = false
  upper            = false
}

resource "azurerm_container_registry" "acr" {
  name                          = "aksobservability${random_string.acr.result}"
  resource_group_name           = data.azurerm_resource_group.aks-observability.name 
  location                      = data.azurerm_resource_group.aks-observability.location
  sku                           = "Premium"
  public_network_access_enabled = true
  admin_enabled                 = true
}

resource "azurerm_role_assignment" "aks-acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-observability.kubelet_identity.0.object_id
}