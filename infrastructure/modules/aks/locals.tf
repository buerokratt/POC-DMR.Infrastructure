locals {

  default_node = {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v3"
  }

  application_node = {
    name       = "applications"
    node_count = 3
    vm_size    = "Standard_D2_v3"
  }

  nodes_resource_group        = "${var.name}-nodes-rg"
  public_ip_domain_name_label = "${var.name}-ingress"
  public_ip_sku               = "Standard"

  health_endpoint = "/healthz"
}
