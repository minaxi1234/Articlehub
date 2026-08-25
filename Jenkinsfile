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

        stage('Trivy Security Scan') {
            steps {
                sh 'trivy image ${DOCKER_USER}/articlehub-backend:latest'
                sh 'trivy image ${DOCKER_USER}/articlehub-frontend:latest'
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

        stage('Deploy with Ansible') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'articlehub-ssh',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    ),
                    string(
                        credentialsId: 'articlehub-db-password',
                        variable: 'DB_PASSWORD'
                    )
                ]) {

                    sh '''
                        chmod 600 "$SSH_KEY"

                        ANSIBLE_HOST_KEY_CHECKING=False \
                        ansible-playbook \
                        -i ansible/inventory \
                        ansible/playbook.yml \
                        --private-key "$SSH_KEY" \
                        -u "$SSH_USER" \
                        -e "db_host=articlehub-postgres.czaaui0cgz5u.ap-south-1.rds.amazonaws.com" \
                        -e "db_port=5432" \
                        -e "db_user=articlehub_user" \
                        -e "db_password=$DB_PASSWORD" \
                        -e "db_name=my_db"
                    '''
                }
            }
        }

    }
}