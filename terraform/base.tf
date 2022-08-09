terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
    host = "${azurerm_kubernetes_cluster.aks-observability.kube_config.0.host}"

    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks-observability.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.aks-observability.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks-observability.kube_config.0.cluster_ca_certificate)}"
}

variable "aks-observability-rg" {
  type    = string
  default = "aks-observability"
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "ACR Name"
}



data "azurerm_resource_group" "aks-observability" {
    name = var.aks-observability-rg
}