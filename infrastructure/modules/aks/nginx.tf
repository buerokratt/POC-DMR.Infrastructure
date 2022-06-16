#
# Deploy Nginx Ingress Controller to the AKS cluster
#

resource "azurerm_public_ip" "nginx_ingress" {
  name                = "${var.name}-ingress-pip"
  resource_group_name = local.node_resource_group
  location            = var.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.name}-ingress"

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = kubernetes_namespace.nginx_ingress.metadata.0.name
  create_namespace = true

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = azurerm_public_ip.nginx_ingress.domain_name_label
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.nginx_ingress.ip_address
  }
}
