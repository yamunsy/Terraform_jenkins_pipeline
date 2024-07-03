pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/RokeshN/Terraform_jenkins_pipeline'
            }
        }
           stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
           stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
            stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }   stage('Terraform destroy') {
            steps {
                sh 'terraform destroy --auto-approve'      
           }
       }
    }
}
