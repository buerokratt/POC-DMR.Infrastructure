resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = var.name
  node_resource_group = local.node_resource_group

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "application_pool" {
  name                  = "applications"
  node_count            = 3
  vm_size               = "Standard_D2_v3"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
}