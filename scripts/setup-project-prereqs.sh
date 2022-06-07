#!/bin/bash

location="westeurope"
resourceGroup="byk-admin-rg"
keyVault="byk-admin-kv"
storage="bykadminstg"

# Create admin resource group.
if [ $(az group exists --name $resourceGroup) = false ]; then 
   az group create --name $resourceGroup --location "$location" 
else
   echo $resourceGroup
fi

# Create KeyVault used by AKS provisioning to store kubectl config and other secrets.
#   This is re-entrant. Safe to run again.
az keyvault create --name $keyVault --resource-group $resourceGroup --location $location

# Create storage account used to store the .tfstate files for environments.
#   This is re-entrant. Safe to run again.
az storage account create --name $storage --resource-group $resourceGroup --location $location --https-only true