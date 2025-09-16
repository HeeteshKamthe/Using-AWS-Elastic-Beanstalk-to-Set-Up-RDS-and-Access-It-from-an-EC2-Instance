#!/bin/bash

# Variables
DB_HOST="<RDS-endpoint>"      # Replace with your RDS endpoint
DB_NAME="test_db"
USERNAME_PARAM="/project/db-username"
PASSWORD_PARAM="/project/db-password"

# Fetch DB credentials from Parameter Store
DB_USER=$(aws ssm get-parameter --name "$USERNAME_PARAM" --with-decryption --query "Parameter.Value" --output text)
DB_PASS=$(aws ssm get-parameter --name "$PASSWORD_PARAM" --with-decryption --query "Parameter.Value" --output text)

# Perform DB Operations
echo "Creating database '$DB_NAME' if not exists..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

echo "Listing all databases..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;"
