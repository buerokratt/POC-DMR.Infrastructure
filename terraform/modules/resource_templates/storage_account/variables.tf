variable "name" {
    type = string
    description = "(Required) Specifies the name of the storage account"
}

variable "resource_group_name" {
    type = string
    description = "(Required) Specifies the name of the resource group in which to create the storage account"
}

variable "location" {
    type = string
    description = "(Required) Specifies the supported Azure location where the resource exists"
}

variable "account_tier" {
    type = string
    description = "(Required) Specifies the tier to use for this storage account. Valid options are: [Standard,Premium]. For BlockBlobStorage and FileStorage accounts only [Premium]"
}

variable "account_replication_type" {
    type = string
    description = "(Required) Specifies the type of replication to use for this storage account. Valid options are: [LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS]"
}
