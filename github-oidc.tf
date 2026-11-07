# GitHub Actions OIDC Role for CI/CD
# Allows GitHub Actions to assume this role via OIDC for secure credential-less authentication

locals {
  github_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
  github_repo              = "pro-digital-uk/team-bravo-infra"
}

# Trust policy for GitHub OIDC
data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [local.github_oidc_provider_arn]
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

# Output the role ARN for reference
output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC role"
  value       = aws_iam_role.github_actions.arn
}
