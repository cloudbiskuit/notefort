-- Initialization script for mysqlb database
CREATE DATABASE IF NOT EXISTS mysqlb;

USE mysqlb;

CREATE TABLE IF NOT EXISTS main (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ida INT NOT NULL,
    msgcp VARCHAR(255) NOT NULL
);
