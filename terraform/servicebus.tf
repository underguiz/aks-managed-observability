resource "random_string" "servicebus" {
  length           = 6
  special          = false
}

resource "azurerm_servicebus_namespace" "aks-observability" {
  name                = "aks-observability-${random_string.servicebus.result}"
  resource_group_name = data.azurerm_resource_group.aks-observability.name 
  location            = data.azurerm_resource_group.aks-observability.location
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "orders" {
  name         = "orders"
  namespace_id = azurerm_servicebus_namespace.aks-observability.id
}

resource "azurerm_servicebus_queue_authorization_rule" "order-app" {
  name     = "orderapp"
  queue_id = azurerm_servicebus_queue.orders.id

  listen = true
  send   = true
  manage = true
}

resource "kubernetes_secret" "service-bus-connection" {
  metadata {
    name = "service-bus-connection"
  }

  data = {
    primary-connection-string = azurerm_servicebus_queue_authorization_rule.order-app.primary_connection_string
  }

}