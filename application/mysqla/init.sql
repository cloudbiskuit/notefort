-- Initialization script for mysqla database
CREATE DATABASE IF NOT EXISTS mysqla;

USE mysqla;

CREATE TABLE IF NOT EXISTS main (
    id INT AUTO_INCREMENT PRIMARY KEY,
    msg VARCHAR(255) NOT NULL
);
