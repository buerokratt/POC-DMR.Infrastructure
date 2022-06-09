data "azurerm_resource_group" "resource_group" { name = var.resource_group_name }

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  domain_name_label   = var.public_ip_name
}


resource "azurerm_traffic_manager_profile" "traffic_manager_profile" {
  name                   = var.traffic_manager_name
  resource_group_name    = data.azurerm_resource_group.resource_group.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = var.traffic_manager_name
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

resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_azure_endpoint" {
  name               = var.traffic_manager_endpoint_name
  profile_id         = azurerm_traffic_manager_profile.traffic_manager_profile.id
  weight             = 100
  target_resource_id = azurerm_public_ip.public_ip.id
}