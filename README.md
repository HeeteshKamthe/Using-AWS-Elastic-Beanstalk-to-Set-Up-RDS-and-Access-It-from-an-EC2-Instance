# 📚 Using AWS Elastic Beanstalk to Set Up RDS and Access It from an EC2 Instance

## 🛠️ Technologies & Tools:
- AWS Elastic Beanstalk
- Amazon RDS (MySQL/PostgreSQL)
- Amazon EC2
- VPC/Subnet/Security Groups
- (Optional: AWS Systems Manager, CloudWatch)

## 🏗️ Architecture Diagram

```plaintext
+------------------+          +---------------------+
| Elastic Beanstalk| <------> | Amazon RDS          |
| (Web App Server) |          | (MySQL/PostgreSQL) |
+------------------+          +---------------------+
           |
           | (Same VPC/Subnet)
           ↓
+------------------+
| EC2 Instance     |
| (Database Client)|
+------------------+
```


## ✅ Step-by-Step Setup Guide

### Step 1: Elastic Beanstalk Environment Setup

1. Create a new Elastic Beanstalk application using Node.js, Python Flask, or PHP (Upload a ZIP file of code or program).

2. During environment creation:

- Select the option to create an integrated RDS instance (MySQL or PostgreSQL).

- Ensure the RDS instance is launched in the same VPC as Elastic Beanstalk.

### Step 2: Configure RDS Database

1. After deployment, note the RDS Endpoint and database credentials from the Elastic Beanstalk console.

2. Modify the RDS security group:

    - Add inbound rule to allow database port (3306 for MySQL or 5432 for PostgreSQL).

    - Set the source to:

        - Elastic Beanstalk environment’s security group.

        - EC2 instance’s security group.

3. (Optional) Enable Public Accessibility only if secure external access is required.

### Step 3: EC2 Instance Setup

1. Launch a separate EC2 instance in the same VPC as the RDS instance.

2. SSH into the EC2 instance:

```bash
ssh -i your-key.pem ec2-user@<EC2-Public-IP>
```

1. Install the database client:
```bash
## For MySQL
sudo yum install -y mysql

## For PostgreSQL
sudo yum install -y postgresql
```
### Step 4: Access RDS from EC2

1. Connect to the RDS database using the endpoint and credentials:
```bash
# MySQL Example
mysql -h <RDS-endpoint> -u <db-user> -p

# PostgreSQL Example
psql -h <RDS-endpoint> -U <db-user> -d <db-name>
```

2. Create a Database & Table:
```sql
CREATE DATABASE registration;
USE registration;

CREATE TABLE users (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    comment TEXT,
    gender VARCHAR(10)
);
```
--- 

## ✅ Optional Enhancements Implementation Steps
### 🔐 1. Store RDS Credentials Securely
#### Step 1: Store Credentials in AWS Systems Manager Parameter Store

1. Open AWS Systems Manager Console → Parameter Store → Create Parameter.

2. Create parameters:

- Name: /project/db-username

- Type: SecureString

- Value: <db-username>


And:

- Name: /project/db-password

- Type: SecureString

- Value: <db-password>

#### Step 2: Access Stored Credentials from EC2 Instance

1. Install AWS CLI if not already installed:
```bash
sudo yum install -y aws-cli
```

2. Retrieve credentials securely:
```bash
aws ssm get-parameter --name "/project/db-username" --with-decryption --query "Parameter.Value" --output text
aws ssm get-parameter --name "/project/db-password" --with-decryption --query "Parameter.Value" --output text
```

### 🧱 2. Add Test Script for Database Operations
#### Step 1: Create a Script test_db.sh on EC2
```bash
#!/bin/bash

DB_HOST="<RDS-endpoint>"
DB_USER=$(aws ssm get-parameter --name "/project/db-username" --with-decryption --query "Parameter.Value" --output text)
DB_PASS=$(aws ssm get-parameter --name "/project/db-password" --with-decryption --query "Parameter.Value" --output text)

# Example MySQL Operations
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "CREATE DATABASE IF NOT EXISTS test_db;"
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "SHOW DATABASES;"
```
#### Step 2: Make Script Executable and Run It
```bash
chmod +x test_db.sh
./test_db.sh
```

### 📊 3. Set Up Monitoring Using Amazon CloudWatch
#### Step 1: Create CloudWatch Alarm for RDS Metrics

- Go to AWS Management Console → CloudWatch → Alarms → Create Alarm.

- Select RDS Metrics → Choose metrics like:

    - CPUUtilization

    - FreeStorageSpace

    - DatabaseConnections

- Set threshold (e.g., CPUUtilization > 80%).

#### Step 2: Configure Alarm Actions

- Set notification (e.g., send email using SNS topic).

#### These steps help you:

    - Keep credentials safe.

    - Test DB access automatically.

    - Monitor RDS health in production.

---

### ✅ How to Use the Script

1. Replace <RDS-endpoint> with your actual RDS endpoint URL.

2. Upload the script to the EC2 instance (or create it directly):
```bash
nano test_db.sh
# Paste the script content, save and exit
```

3. Make the script executable:
```bash
chmod +x test_db.sh
```

4. Run the script:
```bash
./test_db.sh
```

### ✅ What the Script Does

- Retrieves DB username and password securely from Parameter Store.

- Creates a database named test_db (if not already present).

- Lists all available databases on the RDS instance.

---
### Screenshots

🖼️ EB Enviornment Status 
<p align="center"> <img src="img/eb-status.jpg" alt="EB Enviornment Status " width="500"/> </p>

🖼️ RDS Status
<p align="center"> <img src="img/rds-status.jpg" alt="RDS Status" width="500"/> </p>

🖼️ Security Group of EB 
<p align="center"> <img src="img/eb-sg.jpg" alt="Security Group of EB" width="500"/> </p>

🖼️ Security Group of EC2 
<p align="center"> <img src="img/ec2-sg.jpg" alt="Security Group of EC2" width="500"/> </p>

🖼️ Upload Code ZIP file
<p align="center"> <img src="img/code-upload.jpg" alt="Security Group of EC2" width="500"/> </p>

🖼️ Live Application Forms Page
<p align="center"> <img src="img/form.jpg" alt="Live Application Forms Page" width="500"/> </p>

🖼️ Succesful Submission to RDS
<p align="center"> <img src="img/submit.jpg" alt="Succesful Submission to rds" width="500"/> </p>

🖼️ Database Record
<p align="center"> <img src="img/data-record.jpg" alt="Database Record" width="500"/> </p>

---

### 🔐 Security Considerations

- ✅ Do NOT enable Public Accessibility unless absolutely necessary.

- ✅ Configure RDS security group to allow inbound access only from:

    - Elastic Beanstalk security group.

    - Specific EC2 instance security group.

- ✅ Avoid hardcoding database credentials in application code or scripts.

- ✅ Use AWS Systems Manager Parameter Store or Secrets Manager to store credentials securely.

- ✅ Regularly monitor CloudWatch metrics for RDS to detect unusual activity.

