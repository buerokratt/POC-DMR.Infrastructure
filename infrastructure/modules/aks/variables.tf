variable "name" {
  description = "Name of the azure kubernetes cluster"
  type        = string
}

variable "resource_group" {
  description = "The resource group"
  type = object({
    name     = string,
    location = string
  })
}
