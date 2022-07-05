#
# Deploy external_dns to the AKS cluster
#

resource "helm_release" "external_dns" {
  name  = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "external-dns"
  version = "6.6.0"
  namespace = kubernetes_namespace.cert_manager.metadata.0.name

  set {
    name = "provider"
    value = "azure"
  }

  set {
    name = "azure.resourceGroup"
    value = "byk-pr49-rg"
  }

  set {
    name = "azure.tenantId"
    value = "f07d0cf4-e7c8-4845-a07f-905e63651955"
  }

  set {
    name = "azure.subscriptionId"
    value = "b683ce64-51fa-4215-8064-e42408230343"
  }

  set {
    name = "azure.useManagedIdentityExtension"
    value = "true"
  }

  set {
    name = "logLevel"
    value = "debug"
  }

  set {
    name = "domainFilters"
    value = "byk-pr49-aks-ingress.westeurope.cloudapp.azure.com"
  }

  set {
    name = "txtOwnerId"
    value = "external-dns"
  }
}
