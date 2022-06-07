# Force sub module to use github's official provider
terraform {
  required_providers {
    github = {
      source                = "integrations/github"
      version               = "4.26.0"
      configuration_aliases = [github]
    }
  }
}