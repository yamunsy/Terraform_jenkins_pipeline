pipeline {
    agent any


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/RokeshN/terraform-jenkins-pipeline'
            }
        }
