data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_traffic_manager_profile" "traffic_manager_profile" {
  name                   = var.name
  resource_group_name    = data.azurerm_resource_group.resource_group.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = var.name
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "Production"
  }
}

# TODO:
# resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_azure_endpoint" {
#   name               = var.endpoint_name
#   profile_id         = azurerm_traffic_manager_profile.traffic_manager_profile.id
#   weight             = 100
#   target_resource_id = var.aks_public_ip_id
# }