data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_resource_group" "aks_nodes_resource_group" {
  name     = "${var.name}-pip-rg"
  location = data.azurerm_resource_group.resource_group.location
}

resource "azurerm_public_ip" "aks_pip" {
  name                = "${var.name}-pip"
  resource_group_name = azurerm_resource_group.aks_nodes_resource_group.name
  location            = azurerm_resource_group.aks_nodes_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.name}-ingress"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.name
  node_resource_group = "${var.name}-nodes-rg"

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
