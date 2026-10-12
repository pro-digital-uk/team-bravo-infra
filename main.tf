data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  name = "${var.project_name}-${var.environment}"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)
}

# ---------------------------------------------------------------------------
# Network: web (public), app (private) and data (isolated) subnets
# ---------------------------------------------------------------------------
module "vpc" {
  #source = "../../modules/vpc"
  #source              = "github.com/cloud-skills-uk/aws-terraform-modules//vpc"
  source              = "git@github.com:pro-digital-uk/aws-terraform-modules//vpc"
  name                = local.name
  cidr_block          = var.vpc_cidr
  azs                 = local.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  enable_nat_gateway  = var.enable_nat_gateway
}













# module "security_groups" {
#   source = "../../modules/security-groups"

#   name               = local.name
#   vpc_id             = module.vpc.vpc_id
#   allowed_http_cidrs = var.allowed_http_cidrs
#   app_port           = 8080
#   db_port            = 3306
# }

# # ---------------------------------------------------------------------------
# # Key pair for EC2 access
# # ---------------------------------------------------------------------------
# module "keypair" {
#   source = "../../modules/keypair"
# }

# # ---------------------------------------------------------------------------
# # Data tier storage: private, versioned, encrypted S3 bucket
# # ---------------------------------------------------------------------------
# module "s3_assets" {
#   source = "../../modules/s3"

#   bucket_name   = "${local.name}-assets-${data.aws_caller_identity.current.account_id}"
#   force_destroy = var.force_destroy_bucket
# }

# # ---------------------------------------------------------------------------
# # Web tier: static website hosting via S3
# # ---------------------------------------------------------------------------
# module "s3_website" {
#   source = "../../modules/s3-website"

#   bucket_name            = "${local.name}-website-${data.aws_caller_identity.current.account_id}"
#   index_document         = "index.html"
#   error_document         = "index.html"
#   enable_versioning      = false
#   upload_index_document  = true
#   index_document_path    = "${path.module}/../../index.html"
#   allowed_principal_org_id = null
# }

# # ---------------------------------------------------------------------------
# # Web tier: Nginx in a public subnet
# # ---------------------------------------------------------------------------
# module "web" {
#   source = "../../modules/ec2"

#   name                        = "${local.name}-web"
#   subnet_id                   = module.vpc.public_subnet_ids[0]
#   instance_type               = var.instance_type
#   associate_public_ip_address = true
#   s3_bucket_arns              = [module.s3_assets.bucket_arn]
#   user_data                   = templatefile("${path.module}/user_data/web.sh.tftpl", { environment = var.environment })

#   security_group_ids = [module.security_groups.web_sg_id]
# }

# # ---------------------------------------------------------------------------
# # App tier: private subnet, no public IP
# # ---------------------------------------------------------------------------
# module "app" {
#   source = "../../modules/ec2"

#   name           = "${local.name}-app"
#   subnet_id      = module.vpc.app_subnet_ids[0]
#   instance_type  = var.instance_type
#   s3_bucket_arns = [module.s3_assets.bucket_arn]
#   user_data      = templatefile("${path.module}/user_data/app.sh.tftpl", { environment = var.environment })

#   security_group_ids = [module.security_groups.app_sg_id]
# }
