locals {
  current_timestamp = timestamp()
}


data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.aks_name

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}

data "github_actions_public_key" "infra" {
  repository = "../buerokratt/Infrastructure"
}

resource "github_actions_secret" "store_kubeconfig" {
  repository      = "../buerokratt/Infrastructure"
  secret_name     = "Kubeconfig__${replace(var.aks_name, "-", "_")}"
  encrypted_value = base64encode(azurerm_kubernetes_cluster.aks.kube_config_raw)
  depends_on = [
    data.github_actions_public_key.infra,
    azurerm_kubernetes_cluster.aks
  ]
}
