#
# Deploy Nginx Ingress Controller to the AKS cluster
#

data "azurerm_public_ip" "ingress" {
  name                = var.ingress_public_ip_name
  resource_group_name = var.resource_group_name
}

resource "helm_release" "nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = local.applications_namespace
  create_namespace = true

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = var.ingress_health_endpoint
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = data.azurerm_public_ip.ingress.domain_name_label
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = data.azurerm_public_ip.ingress.ip_address
  }
}
