resource "azurerm_log_analytics_workspace" "aks-observability" {
  name                = "aks-observability"
  location            = data.azurerm_resource_group.aks-observability.location
  resource_group_name = data.azurerm_resource_group.aks-observability.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 1
}