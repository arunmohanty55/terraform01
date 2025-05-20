terraform {
  backend "remote" {
    organization = "your-org-name"

    workspaces {
      name = "login-page-infra"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
