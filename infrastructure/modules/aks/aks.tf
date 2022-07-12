resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = var.name
  node_resource_group = local.nodes_resource_group

  default_node_pool {
    name       = local.default_node.name
    node_count = local.default_node.node_count
    vm_size    = local.default_node.vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "application_pool" {
  name                  = local.application_node.name
  node_count            = local.application_node.node_count
  vm_size               = local.application_node.vm_size
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
}

resource "azurerm_key_vault_secret" "kubeconfig" {
  key_vault_id = var.keyvault_id
  name         = "KubeConfig"
  value        = azurerm_kubernetes_cluster.aks.kube_config_raw
}

resource "kubernetes_namespace" "applications" {
  metadata {
    name = "applications"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
