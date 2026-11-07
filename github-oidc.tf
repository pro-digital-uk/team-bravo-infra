# GitHub Actions OIDC Identity Provider and Role for CI/CD
# Allows GitHub Actions to assume a role via OIDC for secure credential-less authentication

locals {
  github_oidc_url          = "token.actions.githubusercontent.com"
  github_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.github_oidc_url}"
  github_repo              = "pro-digital-uk/team-bravo-infra"
  # GitHub's OIDC provider certificate thumbprint
  # https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
  github_oidc_thumbprint = "d367a47959a77b088bec4fe3e7dd3ec9ba733ab5"
}

# Create AWS OIDC Provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://${local.github_oidc_url}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.github_oidc_thumbprint]

  tags = {
    Name        = "github-oidc-provider"
    ManagedBy   = "terraform"
    Environment = "ci-cd"
  }
}

# Trust policy for GitHub OIDC
data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.github_repo}:*"]
    }
  }
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name               = "github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json

  tags = {
    Name        = "github-actions-role"
    ManagedBy   = "terraform"
    Environment = "ci-cd"
  }
}

# Policy for Terraform operations on AWS resources
data "aws_iam_policy_document" "github_actions_terraform" {
  statement {
    sid    = "TerraformStateAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::terraform-state-${data.aws_caller_identity.current.account_id}",
      "arn:aws:s3:::terraform-state-${data.aws_caller_identity.current.account_id}/*"
    ]
  }

  statement {
    sid    = "TerraformFullAccess"
    effect = "Allow"
    actions = [
      "ec2:*",
      "s3:*",
      "vpc:*",
      "tag:*",
      "autoscaling:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "IAMReadOnly"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:GetUser",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions"
    ]
    resources = ["*"]
  }
}

# Attach the policy to the GitHub Actions role
resource "aws_iam_role_policy" "github_actions_terraform" {
  name   = "github-actions-terraform-policy"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions_terraform.json
}

# Outputs
output "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC role"
  value       = aws_iam_role.github_actions.arn
}
