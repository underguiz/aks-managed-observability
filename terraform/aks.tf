resource "azurerm_kubernetes_cluster" "aks-observability" {
  name                = "aks-observability"
  dns_prefix          = "aks-observability"
  resource_group_name = data.azurerm_resource_group.aks-observability.name
  location            = data.azurerm_resource_group.aks-observability.location

  role_based_access_control_enabled = true

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks-observability.id
  }

  default_node_pool {
    name                = "app"
    vm_size             = "Standard_D4as_v4"
    enable_auto_scaling = false
    node_count          = 3
    vnet_subnet_id      = azurerm_subnet.app.id
  }

  network_profile {
    network_plugin     = "kubenet"
    pod_cidr           = "172.16.0.0/16"
    service_cidr       = "172.29.100.0/24"
    dns_service_ip     = "172.29.100.10"
    docker_bridge_cidr = "172.29.101.0/24"  
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_role_assignment" "aks-subnet" {
  scope                = azurerm_virtual_network.aks-observability.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-observability.identity.0.principal_id
}