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

resource "kubernetes_manifest" "cluster_issuer_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email  = "buerokratt@ria.ee"
        privateKeySecretRef = {
          name = "letsencrypt-staging"
        }
        solvers = [{
          http01 = {
            ingress = {
              class = "nginx"
            }
          }
        }]
      }
    }
  }
  wait {
    fields = {
      "status.loadBalancer.ingress[0].ip" = "^(\\d+(\\.|$)){4}"
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.application_pool
  ]
}

resource "kubernetes_manifest" "cluster_issuer_prod" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "buerokratt@ria.ee"
        privateKeySecretRef = {
          name = "letsencrypt"
        }
        solvers = [{
          http01 = {
            ingress = {
              class = "nginx"
            }
          }
        }]
      }
    }
  }
  wait {
    fields = {
      "status.loadBalancer.ingress[0].ip" = "^(\\d+(\\.|$)){4}"
    }
  }
  depends_on = [
    kubernetes_manifest.cluster_issuer_staging,
    azurerm_kubernetes_cluster_node_pool.application_pool
  ]
}
