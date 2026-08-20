pipeline {
    agent any

    environment {
        DOCKER_USER = 'meenakshisunil'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/minaxi1234/Articlehub.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t ${meenakshisunil}/articlehub-backend:latest ./backend'
                sh 'docker build -t ${meenakshisunil}/articlehub-frontend:latest ./frontend'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-articlehub',
                        usernameVariable: 'meenakshisunil',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

                        docker push ${meenakshisunil}/articlehub-backend:latest
                        docker push ${meenakshisunil}/articlehub-frontend:latest

                        docker logout
                    '''
                }
            }
        }
    }
}