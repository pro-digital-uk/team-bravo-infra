terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Remote state is recommended for teams. Create the bucket and lock table first, then uncomment.
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "three-tier/dev/terraform.tfstate"
  #   region         = "eu-west-2"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Name        = var.environment_name
      Project     = var.project_name
      Team        = var.team_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
