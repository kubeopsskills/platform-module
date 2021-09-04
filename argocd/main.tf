terraform {
  required_providers {
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.11.0"
    }
  }
}