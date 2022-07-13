output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "ingress" {
  value = {
    pip_id          = azurerm_public_ip.ingress.id
    pip_name        = azurerm_public_ip.ingress.name
    health_endpoint = local.health_endpoint
  }
}
