terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
