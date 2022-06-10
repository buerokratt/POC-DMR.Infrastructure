output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "aks_pip" {
  value = {
    name = azurerm_public_ip.aks_pip.name
    resource_group_name = azurerm_public_ip.aks_pip.resource_group_name
  }
}