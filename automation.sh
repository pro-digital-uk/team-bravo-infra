#!/usr/bin/env bash

set -euo pipefail

# Install git, Terraform, Jenkins and make separately if required.

echo "Removing Existing Terraform Files ...."
#sleep 1
rm -rf team-alpha-infra

echo "Cloning Git Repository ...."
git clone git@github.com:pro-digital-uk/team-alpha-infra.git 


echo "Changing Directory ...."
cd team-alpha-infra

ls -la

echo "Starting Terraform Initialisation"
#sleep 1
terraform init

echo "Starting Terraform Plan"
#sleep 1
terraform plan

echo "Starting Terraform Apply"
#sleep 1
terraform apply

echo "Terraform deployment completed successfully."


#terraform destroy
