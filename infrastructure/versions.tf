# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  required_version = ">= 1.1.0"

  backend "azurerm" {}

  # LOCAL DEV: Comment out the block above 'backend "azurerm" {}' and uncomment/use the backend block 
  # below when deploying locally - this ensure tfstate to be stored locally/remotely

  #backend "local" {
  #  path = "/terraform.tfstate"
  #}
}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.aks.fqdn
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  token                  = azurerm_kubernetes_cluster.aks.token
  load_config_file       = true

  alias = "aks"

  environment {
    KUBECONFIG = azurerm_kubernetes_cluster.aks.kube_config
  }
}

provider "helm" {
  kubernetes {
    # config_path = "~/.kube/config"
    # host                   = azurerm_kubernetes_cluster.aks.fqdn
    # cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["aks", "get-credentials", "--name", local.aks_name, "--resource-group", local.resource_group_name]
      command     = "az"
    }
  }
}

