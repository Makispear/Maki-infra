terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket  = "maki-terraform-state-storage"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # Replace dynamodb_table with this for the new locking mechanism
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "github_token" {
  description = "PAT for GitHub"
  type        = string
  sensitive   = true # prevents token leaking in terminal logs
}

# Configure the provider once
provider "github" {
  owner = "Makispear"
  token = var.github_token
}
