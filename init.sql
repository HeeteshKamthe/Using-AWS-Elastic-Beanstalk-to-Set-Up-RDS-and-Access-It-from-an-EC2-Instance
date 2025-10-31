-- Create database
CREATE DATABASE IF NOT EXISTS registration;

-- Select the database
USE registration;

-- Create 'users' table
CREATE TABLE IF NOT EXISTS users (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    comment TEXT,
    gender VARCHAR(10)
);

