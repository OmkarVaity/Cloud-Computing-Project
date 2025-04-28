# Cloud Computing Projects Collection

This repository contains a collection of projects completed during my **Cloud Computing coursework**, showcasing practical implementations across **API Development**, **Infrastructure as Code (IaC) using Terraform**, and **Serverless Architectures**.

---

## 📈 Projects Overview

### 1. WebApp (API Server)
- **Technology Stack**: Node.js, JavaScript
- **Description**: A backend API server built with Node.js, designed to be deployed on the cloud and accessed through tools like Postman.
- **Key Features**:
  - REST API Endpoints
  - Handles HTTP requests and responses
  - Ready for deployment on cloud infrastructure

### 2. Terraform AWS Infrastructure (`tf-aws-infra`)
- **Technology Stack**: Terraform (HCL)
- **Description**: Infrastructure-as-Code scripts for automating AWS resource provisioning.
- **Key Features**:
  - VPC setup and configuration
  - EC2 instances deployment
  - S3 bucket provisioning
  - IAM role and policy creation
  - Load balancer and auto-scaling setup

### 3. Serverless Application (`serverless`)
- **Technology Stack**: Serverless Framework, AWS Lambda, API Gateway
- **Description**: A serverless architecture project deploying functions triggered via HTTP endpoints.
- **Key Features**:
  - Lambda function deployment
  - REST API creation using API Gateway
  - Event-driven execution model

---

## 🛠️ How to Run Each Project

### WebApp (Backend API)
```bash
cd webapp
npm install
npm start
```
> The server will start on a configured port (e.g., `http://localhost:3000`).

Use **Postman** (or any API client) to send requests to the API endpoints.

---

### Terraform AWS Infrastructure
```bash
cd tf-aws-infra
terraform init
terraform plan
terraform apply
```
> Make sure your AWS CLI is configured with appropriate credentials.

---

### Serverless Application
```bash
cd serverless
npm install
serverless deploy
```
This will deploy the Lambda functions and setup API Gateway.

---

## 🌐 Technologies Used
- Node.js (Backend API)
- Terraform (Infrastructure as Code)
- Serverless Framework
- AWS Services (EC2, S3, Lambda, API Gateway, IAM)
- GitHub and Git Version Control

---

## 📑 Notes
- Terraform state files should ideally be managed remotely for production use.
- AWS credentials should be securely managed using environment variables or AWS profiles.
- Ensure required IAM permissions for infrastructure and serverless deployments.

---


---

Thank you for visiting! Feel free to ⭐️ this repository if you find it helpful!
