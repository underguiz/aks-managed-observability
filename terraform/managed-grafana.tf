resource "azapi_resource" "managed-grafana" {
  type      = "Microsoft.Dashboard/grafana@2021-09-01-preview"
  name      = "aks-observability"
  parent_id = data.azurerm_resource_group.aks-observability.id
  location  = data.azurerm_resource_group.aks-observability.location

  identity {
    type         = "SystemAssigned"
  }

  body = jsonencode({
    properties = {
      zoneRedundancy = "Enabled"
    }
  })

  # ignore_missing_property = true

}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "managed-grafana-admin" {
  scope                = azapi_resource.managed-grafana.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "managed-grafana-log-analytics" {
  scope                = azurerm_log_analytics_workspace.aks-observability.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azapi_resource.managed-grafana.identity.0.principal_id
}