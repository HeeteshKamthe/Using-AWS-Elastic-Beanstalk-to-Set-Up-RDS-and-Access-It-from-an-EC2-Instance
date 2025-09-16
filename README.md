# 📚 Using AWS Elastic Beanstalk to Set Up RDS and Access It from an EC2 Instance

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

1. Create a new Elastic Beanstalk application using Node.js, Python Flask, or PHP.

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

2. Test read/write operations:
```sql
CREATE DATABASE test_db;
SHOW DATABASES;
```

### 🔐 Security Considerations

- ✅ Do NOT enable Public Accessibility unless absolutely necessary.

- ✅ Configure RDS security group to allow inbound access only from:

    - Elastic Beanstalk security group.

    - Specific EC2 instance security group.

- ✅ Avoid hardcoding database credentials in application code or scripts.

- ✅ Use AWS Systems Manager Parameter Store or Secrets Manager to store credentials securely.

- ✅ Regularly monitor CloudWatch metrics for RDS to detect unusual activity.
