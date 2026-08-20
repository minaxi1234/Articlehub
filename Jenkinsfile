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
        sh 'docker build -t ${DOCKER_USER}/articlehub-backend:latest ./backend'
        sh 'docker build -t ${DOCKER_USER}/articlehub-frontend:latest ./frontend'
    }
}

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-articlehub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

                        docker push ${DOCKER_USER}/articlehub-backend:latest
                        docker push ${DOCKER_USER}/articlehub-frontend:latest

                        docker logout
                    '''
                }
            }
        }
    }
}