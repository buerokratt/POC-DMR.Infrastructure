locals {
  public_ip_name       = "${var.name}-pip"
  public_ip_domain     = "${var.name}-ingress"
  nodes_resource_group = "${var.name}-nodes-rg"
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_public_ip" "aks_pip" {
  name                = local.public_ip_name
  resource_group_name = local.nodes_resource_group
  location            = data.azurerm_resource_group.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = local.public_ip_domain
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.name
  node_resource_group = local.nodes_resource_group

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.aks_pip.id]
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "application_pool" {
  name                  = "applications"
  node_count            = 3
  vm_size               = "Standard_D2_v3"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
}
