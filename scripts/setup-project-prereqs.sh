#!/bin/bash

location="westeurope"
resourceGroup="byk-admin-rg"
keyVault="byk-admin-kv"
storage="bykadminstg"

#
# Create admin resource group
#

if [ $(az group exists --name $resourceGroup) = false ]; then 
   az group create --name $resourceGroup --location "$location" 
else
   echo $resourceGroup
fi

#
# Create keyvault
#

az keyvault create --name $keyVault --resource-group $resourceGroup --location $location

#
# Create storage account
#

# This is re-entrant so re-runs of the same storage name wouldn't recreate/throw an error
az storage account create --name $storage --resource-group $resourceGroup --location $location --https-only true