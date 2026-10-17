output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Web tier subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "app_subnet_ids" {
  description = "App tier subnet IDs."
  value       = module.vpc.app_subnet_ids
}

output "db_subnet_ids" {
  description = "Data tier subnet IDs."
  value       = module.vpc.db_subnet_ids
}

output "db_subnet_group_name" {
  description = "DB subnet group, ready for an RDS instance."
  value       = module.vpc.db_subnet_group_name
}

# output "web_instance_id" {
#   description = "Web tier instance ID. Connect with: aws ssm start-session --target <id>"
#   value       = module.web.instance_id
# }

# output "web_public_ip" {
#   description = "Web tier public IP. Port 80 is only reachable once the security_groups module is enabled."
#   value       = module.web.public_ip
# }

# output "app_instance_id" {
#   description = "App tier instance ID. Session Manager needs the NAT Gateway (or VPC endpoints) from a private subnet."
#   value       = module.app.instance_id
# }

# output "app_private_ip" {
#   description = "App tier private IP."
#   value       = module.app.private_ip
# }

# output "assets_bucket" {
#   description = "Name of the S3 assets bucket."
#   value       = module.s3_assets.bucket_id
# }

# output "website_bucket" {
#   description = "Name of the S3 static website bucket."
#   value       = module.s3_website.bucket_id
# }

# output "website_endpoint" {
#   description = "S3 website endpoint URL (HTTP only)."
#   value       = module.s3_website.website_endpoint
# }

# output "website_bucket_domain" {
#   description = "S3 bucket domain name for static website hosting."
#   value       = module.s3_website.bucket_domain_name
# }

# # output "security_group_ids" {
# #   description = "Tiered security group IDs."
# #   value = {
# #     web = module.security_groups.web_sg_id
# #     app = module.security_groups.app_sg_id
# #     db  = module.security_groups.db_sg_id
# #   }
# # }
