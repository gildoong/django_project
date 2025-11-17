pipeline {
    agent any

    environment {
        REGISTRY = "galdoongd/django_app"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'TOKEN')]) {
                    sh """
                    echo "${TOKEN}" | docker login -u galdoongd --password-stdin
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REGISTRY}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'TOKEN')]) {
                    sh """
                    echo "${TOKEN}" | docker login -u galdoongd --password-stdin
                    docker push ${REGISTRY}:latest
                    """
                }
            }
        }
    }
}

