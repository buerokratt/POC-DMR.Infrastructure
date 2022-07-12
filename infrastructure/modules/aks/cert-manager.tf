#
# Deploy cert_manager to the AKS cluster
#

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.application_pool
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.8.2"
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}

resource "helm_release" "aks_addons" {
  name        = "aks-addons"
  chart       = "${path.module}/addons"
  description = "Addons installed onto the AKS cluster on ${timestamp()}"
  lint        = true
  depends_on = [
    helm_release.cert_manager
  ]
}
