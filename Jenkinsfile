pipeline {
    agent any

    environment {
        REGISTRY = "galdoongd/django_app"  // Docker Hub repo (너 계정명)
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
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
                    echo $TOKEN | docker login -u galdoongd --password-stdin
                    docker push ${REGISTRY}:latest
                    """
                }
            }
        }

        // 배포는 ArgoCD가 담당한다
    }
}
