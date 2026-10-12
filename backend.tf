terraform {
  backend "s3" {
    bucket         = "terraform-state-493245399435"
    key            = "dev/aws-3-tier-alpha/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
