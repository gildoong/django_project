pipeline {
    agent any

    environment {
        REGISTRY = "galdoongd/django_app"
        GIT_SHA = "${env.GIT_COMMIT[0..6]}"
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
                    echo "$TOKEN" | docker login -u galdoongd --password-stdin
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REGISTRY}:${GIT_SHA} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'TOKEN')]) {
                    sh """
                    echo "$TOKEN" | docker login -u galdoongd --password-stdin
                    docker push ${REGISTRY}:${GIT_SHA}
                    """
                }
            }
        }

        stage('Update Deployment File') {
            steps {
                sh """
                sed -i "s|image: ${REGISTRY}:.*|image: ${REGISTRY}:${GIT_SHA}|" k8s/deployment.yaml
                """
            }
        }

        stage('Commit & Push Deployment Update') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    sh """
                    git config user.email "jenkins@example.com"
                    git config user.name "Jenkins"

                    git remote set-url origin https://$GITHUB_TOKEN@github.com/gildoong/django_project.git
                    
                    git add k8s/deployment.yaml
                    git commit -m "Update deployment image to ${GIT_SHA}" || echo "No changes"
                    git push origin HEAD:main
                    """
                }
            }
        }

    }
}

