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

# provider "kubectl" {
#   host                   = azurerm_kubernetes_cluster.aks.fqdn
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#   token                  = azurerm_kubernetes_cluster.aks.token
#   load_config_file       = true

#   alias = "aks"

#   environment {
#     KUBECONFIG = azurerm_kubernetes_cluster.aks.kube_config
#   }
# }

resource "null_resource" "aks_get_creds" {
  triggers = {
    cluster_id = azurerm_kubernetes_cluster.aks.id
  }

  provisioner "local-exec" {
    # command = "az az aks get-credentials -g ${var.resource_group_name} -n ${var.name}"
    command = "ls -R ~/.kube"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "helm_release" "nginx" {
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.13"
  namespace  = "nginx-ingress-ns"

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.nodeSelector.\"kubernetes.io/os"
    value = "linux"
  }

  set {
    name  = "controller.service.annotations.\"service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "defaultBackend.nodeSelector.\"kubernetes.io/os"
    value = "linux"
  }

  set {
    name  = "defaultBackend.image.digest"
    value = ""
  }

  # provisioner "local-exec" {
  #   command = "az aks get-credentials -g ${var.resource_group_name} -n ${var.name}"
  # }

  depends_on = [
    null_resource.aks_get_creds
  ]
}
