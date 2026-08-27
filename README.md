# ArticleHub – CI/CD DevOps Deployment Project

## Overview

ArticleHub is a full-stack article and blog application deployed on AWS using a practical DevOps and CI/CD workflow.

The project demonstrates how a containerized application can be built, security-scanned, pushed to Docker Hub, and automatically deployed to AWS EC2 using Jenkins and Ansible.

## Technologies Used

* React + Vite
* Node.js + Express
* PostgreSQL
* Docker
* Docker Compose
* Jenkins
* Trivy
* Docker Hub
* Ansible
* Terraform
* AWS EC2
* AWS Application Load Balancer
* AWS RDS PostgreSQL
* Nginx

## Architecture

```text
GitHub
   |
   v
Jenkins
   |
   +---- Checkout
   +---- Docker Build
   +---- Trivy Scan
   +---- Push to Docker Hub
   +---- Ansible Deployment
   |
   v
AWS EC2
   |
   +---- Docker Compose
            |
            +---- Frontend :3000
            |
            +---- Backend :5000
   |
   v
Application Load Balancer
   |
   | HTTPS :443
   v
ArticleHub Application
   |
   v
AWS RDS PostgreSQL
```

## CI/CD Pipeline

Jenkins automates the complete Continuous Integration and Continuous Deployment workflow.

The pipeline performs:

1. Checkout source code from GitHub
2. Build the frontend Docker image
3. Build the backend Docker image
4. Scan both images using Trivy
5. Push the images to Docker Hub
6. Deploy the latest images to AWS EC2 using Ansible
7. Start the application using Docker Compose
8. Verify the deployment

### Docker Images

```text
meenakshisunil/articlehub-frontend:latest
meenakshisunil/articlehub-backend:latest
```

## Docker

The application uses two Docker containers:

* articlehub-frontend
* articlehub-backend

The containers communicate through the `articlehub-network`.

### Frontend

EC2 Port 3000 → Container Port 80

### Backend

EC2 Port 5000 → Container Port 5000

## Trivy Security Scanning

Trivy is integrated into the Jenkins pipeline to scan the Docker images for known vulnerabilities before they are pushed to Docker Hub.

Images scanned:

```text
meenakshisunil/articlehub-frontend:latest
meenakshisunil/articlehub-backend:latest
```

## Docker Hub

Jenkins pushes the successfully built and scanned Docker images to Docker Hub.

```text
meenakshisunil/articlehub-frontend:latest
meenakshisunil/articlehub-backend:latest
```

## Ansible Deployment

Ansible is used for Continuous Deployment.

Jenkins uses Ansible to deploy the latest Docker images to the AWS EC2 server.

The deployment includes:

* Connecting to EC2
* Preparing the deployment directory
* Pulling the latest Docker images
* Running Docker Compose
* Starting the frontend and backend containers
* Verifying the deployment

Application directory:

```text
/opt/articlehub
```

## Terraform

Terraform is used as Infrastructure as Code to provision and manage the AWS infrastructure.

The infrastructure includes:

* EC2
* Security Groups
* Application Load Balancer
* Target Group
* ALB Listener
* RDS PostgreSQL

AWS Region:

```text
ap-south-1
```

## AWS EC2

ArticleHub is deployed on an AWS EC2 instance running Docker and Docker Compose.

Deployment directory:

```text
/opt/articlehub
```

## Application Load Balancer

The AWS Application Load Balancer provides public HTTPS access to ArticleHub.

Traffic flow:

```text
User
 |
 v
Application Load Balancer :443
 |
 v
Target Group :3000
 |
 v
EC2
 |
 v
ArticleHub Frontend
```

### Target Group Configuration

* Target Type: Instance
* Protocol: HTTP
* Port: 3000
* Health Check Path: /

The EC2 target was successfully reported as healthy.

## Security Groups

The infrastructure uses AWS Security Groups to control network access.

### ALB Security Group

* HTTPS → 443

### Application Security Group

* SSH → 22
* Frontend → 3000
* Backend → 5000

## AWS RDS PostgreSQL

ArticleHub uses Amazon RDS PostgreSQL as its database.

* Database: `my_db`
* Engine: PostgreSQL
* Port: 5432
* Instance: `db.t3.micro`
* Storage: 20 GB
* Publicly accessible: No

The database is protected using a separate security group and is not directly exposed to the public internet.

## Deployment Verification

The deployment was verified using:

* Jenkins pipeline success
* Successful Ansible deployment
* Running Docker containers
* Healthy AWS Target Group
* HTTPS application access
* HTTP 200 response from the application

## End-to-End Flow

```text
Developer
   |
   v
GitHub
   |
   v
Jenkins
   |
   +---- Checkout
   +---- Docker Build
   +---- Trivy Scan
   +---- Push to Docker Hub
   +---- Ansible Deployment
   |
   v
AWS EC2
   |
   v
Docker Compose
   |
   +---- Frontend
   +---- Backend
   |
   v
Application Load Balancer
   |
   | HTTPS
   v
ArticleHub
   |
   v
AWS RDS PostgreSQL
```

# Project Screenshots

## 01 – ArticleHub Application

![ArticleHub Application](screenshots/01-articlehub-application.png)

## 02 – EC2 Instance

![EC2 Instance](screenshots/02-ec2-instance.png)

## 03 – RDS Database

![RDS Database](screenshots/03-rds-database.png)

## 04 – Application Load Balancer

![Application Load Balancer](screenshots/04-application-load-balancer.png)

## 05 – ALB Listener

![ALB Listener](screenshots/05-alb-listener.png)

## 06 – Target Group Health

![Target Group Health](screenshots/06-target-group-healthy.png)

## 07 – ALB Security Group

![ALB Security Group](screenshots/07-alb-security-group.png)

## 08 – Application Security Group

![Application Security Group](screenshots/08-app-security-group.png)

## 09 – Docker Containers

![Docker Containers](screenshots/09-docker-containers.png)

## 10 – Docker Compose

![Docker Compose](screenshots/10-docker-compose.png)

## 11 – Ansible Playbook

![Ansible Playbook](screenshots/11-ansible-playbook.png)

## 12 – Ansible Deployment Success

![Ansible Deployment Success](screenshots/12-ansible-success.png)

## 13 – Jenkins CI/CD Success

![Jenkins CI/CD Success](screenshots/13-jenkins-cicd-success.png)

## 14 – Terraform Infrastructure

![Terraform Infrastructure](screenshots/14-terraform-infrastructure.png)

## 15 – Terraform Apply

![Terraform Apply](screenshots/15-terraform-apply.png)

## 16 – ALB HTTP 200

![ALB HTTP 200](screenshots/16-alb-http-200.png)

## 17 – Docker Hub Images

![Docker Hub Images](screenshots/17-dockerhub-images.png)

## 18 – Database Images

![Database Images](screenshots/18-db-images.png.png)

## What This Project Demonstrates

* Git and GitHub
* Jenkins CI/CD
* Docker
* Docker Compose
* Trivy Security Scanning
* Docker Hub
* Ansible
* Terraform
* AWS EC2
* AWS Application Load Balancer
* AWS Target Groups
* AWS Security Groups
* AWS RDS PostgreSQL
* Infrastructure as Code
* Continuous Integration
* Continuous Deployment
* Automated Docker image delivery
* Automated application deployment
* Cloud-based application deployment

## Final Result

ArticleHub was successfully containerized and deployed on AWS using a complete CI/CD workflow.

```text
GitHub
   ↓
Jenkins
   ↓
Docker Build
   ↓
Trivy Scan
   ↓
Docker Hub
   ↓
Ansible
   ↓
AWS EC2
   ↓
Docker Compose
   ↓
Application Load Balancer
   ↓
HTTPS
   ↓
ArticleHub
   ↓
AWS RDS PostgreSQL
```

The Jenkins pipeline successfully builds, scans, publishes, deploys, and verifies the ArticleHub application.

## Author

**Meenakshi Sunil**

GitHub: https://github.com/minaxi1234
