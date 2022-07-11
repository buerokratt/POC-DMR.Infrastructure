resource "azurerm_public_ip" "ingress" {
  name                = "${var.name}-ingress-pip"
  resource_group_name = local.nodes_resource_group
  location            = var.resource_group.location
  allocation_method   = "Static"
  sku                 = local.public_ip_sku
  domain_name_label   = local.public_ip_domain_name_label

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}