data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_public_ip" "aks_pip" {
  name                = var.aks_pip.name
  resource_group_name = var.aks_pip.resource_group_name
}

resource "azurerm_traffic_manager_profile" "traffic_manager_profile" {
  name                   = var.name
  resource_group_name    = data.azurerm_resource_group.resource_group.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = var.name
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/healthz"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = var.environment_name
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_azure_endpoint" {
  name               = "aks_cluster"
  profile_id         = azurerm_traffic_manager_profile.traffic_manager_profile.id
  weight             = 100
  target_resource_id = data.azurerm_public_ip.aks_pip.id
}
