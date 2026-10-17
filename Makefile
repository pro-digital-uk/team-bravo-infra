
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := deploy

# Configuration
REPO_URL := git@github.com:pro-digital-uk/team-alpha-infra.git
PROJECT_DIR := team-alpha-infra

.PHONY: all clean clone init plan apply deploy

all: deploy

# Remove existing Terraform project directory
clean:
	@echo "Removing existing Terraform files..."
	rm -rf "$(PROJECT_DIR)"

# Clone repository
clone: clean
	@echo "Cloning Git repository..."
	git clone "$(REPO_URL)" 

# Initialise Terraform
init: clone
	@echo "Starting Terraform initialisation..."
	cd "$(PROJECT_DIR)" && terraform init

# Generate Terraform execution plan
plan: init
	@echo "Starting Terraform plan..."
	cd "$(PROJECT_DIR)" && terraform plan

# Apply Terraform changes
apply: plan
	@echo "Starting Terraform apply..."
	cd "$(PROJECT_DIR)" && terraform apply

# Run the complete workflow
deploy: apply
	@echo "Terraform deployment completed successfully."

# Destroy Terraform-managed infrastructure
destroy: init
	@echo "WARNING: You are about to destroy Terraform-managed infrastructure."
	cd "$(PROJECT_DIR)" && terraform plan -destroy
	@read -r -p "Are you sure you want to destroy this infrastructure? Type 'yes' to continue: " confirm; \
	if [[ "$$confirm" != "yes" ]]; then \
		echo "Destroy cancelled."; \
		exit 1; \
	fi
	cd "$(PROJECT_DIR)" && terraform destroy
