
pipeline {
    agent any

    environment {
        REPO_URL   = 'git@github.com:pro-digital-uk/team-alpha-infra.git'
        PROJECT_DIR = 'team-bravo-infra'
        PATH = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['deploy', 'destroy', 'plan', 'init', 'clean'],
            description: 'Select the Terraform operation to execute'
        )
    }

    stages {
        stage('Check Prerequisites') {
            steps {
                sh '''
                    set -euo pipefail

                    echo "Checking required tools..."
                    command -v git
                    command -v terraform

                    echo "Terraform version:"
                    terraform version
                '''
            }
        }

        stage('Clean') {
            when {
                expression { params.ACTION in ['deploy', 'destroy', 'plan', 'init', 'clean'] }
            }
            steps {
                echo 'Removing existing Terraform project directory...'
                sh 'rm -rf "$PROJECT_DIR"'
            }
        }

        stage('Clone') {
            when {
                expression { params.ACTION in ['deploy', 'destroy', 'plan', 'init'] }
            }
            steps {
                echo 'Cloning Git repository...'
                sh 'git clone "$REPO_URL" "$PROJECT_DIR"'
            }
        }

        stage('Terraform Init') {
            when {
                expression { params.ACTION in ['deploy', 'destroy', 'plan', 'init'] }
            }
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        set -euo pipefail
                        echo "Starting Terraform initialisation..."
                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION in ['deploy', 'plan'] }
            }
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        set -euo pipefail
                        echo "Starting Terraform plan..."
                        terraform plan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'deploy' }
            }
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        set -euo pipefail
                        echo "Starting Terraform apply..."
                        terraform apply
                    '''
                }
            }
        }

        stage('Terraform Destroy Plan') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        set -euo pipefail
                        echo "Creating Terraform destroy plan..."
                        terraform plan -destroy
                    '''
                }
            }
        }

        stage('Confirm Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                input(
                    message: 'WARNING: Do you want to destroy Terraform-managed infrastructure?',
                    ok: 'Confirm Destroy',
                    submitterParameter: 'APPROVED_BY'
                )
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir("${PROJECT_DIR}") {
                    sh '''
                        set -euo pipefail
                        echo "Starting Terraform destroy..."
                        terraform destroy
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.ACTION} operation completed successfully."
        }
        failure {
            echo "ERROR: Terraform ${params.ACTION} operation failed."
        }
        always {
            echo "Pipeline execution finished."
        }
    }
}

