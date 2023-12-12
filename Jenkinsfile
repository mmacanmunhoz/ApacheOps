pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_KEY = credentials('AWS_SECRET_KEY')
    }

    stages {
        stage("Build Packer Image") {
            steps {
                 script {
                      dir('iac/packer/') {
                           sh "packer build -var 'aws_access_key=${AWS_ACCESS_KEY}' -var 'aws_secret_key=${AWS_SECRET_KEY}'"
                           def packerImageId = readFile("ami-id.txt").trim()
                           env.PACKER_IMAGE_ID = packerImageId
                      }
                 }

            }
        }
        stage("Terraform init") {
            steps {
                script {
                    dir('iac/terraform/') {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage("Terraform plan") {
            steps {
                script {
                    dir('iac/terraform/') {
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage("Terraform apply"){
            steps {
                script {
                    dir('iac/terraform/') {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
    }
}
