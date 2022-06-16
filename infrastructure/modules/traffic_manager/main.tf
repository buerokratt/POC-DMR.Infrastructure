locals {
  traffic_routing_method = "Performance"
  dns_ttl                = 100
  endpoint_weighting     = 100

  interval_in_seconds          = 30
  timeout_in_seconds           = 9
  tolerated_number_of_failures = 3
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_traffic_manager_profile" "traffic_manager_profile" {
  name                   = var.name
  resource_group_name    = data.azurerm_resource_group.resource_group.name
  traffic_routing_method = local.traffic_routing_method

  dns_config {
    relative_name = var.name
    ttl           = local.dns_ttl
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = var.aks_ingress_health_endpoint
    interval_in_seconds          = local.interval_in_seconds
    timeout_in_seconds           = local.timeout_in_seconds
    tolerated_number_of_failures = local.tolerated_number_of_failures
  }

  tags = {
    environment = var.environment_name
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_azure_endpoint" {
  name               = "aks_cluster"
  profile_id         = azurerm_traffic_manager_profile.traffic_manager_profile.id
  weight             = local.endpoint_weighting
  target_resource_id = var.aks_pip_id
}
