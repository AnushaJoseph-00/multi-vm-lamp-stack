#!/bin/bash
sudo -i
apt update
apt install -y mariadb-server
systemctl status mariadb

# Edit bind-address in /etc/mysql/mariadb.conf.d/50-server.cnf
# change: bind-address = 127.0.0.1  ->  bind-address = 0.0.0.0
systemctl restart mariadb

mysql <<'SQL'
CREATE DATABASE appdb;
CREATE USER 'appuser'@'192.168.56.%' IDENTIFIED BY 'apppass123';
GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'192.168.56.%';
FLUSH PRIVILEGES;
USE appdb;
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO messages (body) VALUES ('Hello from the database VM!');
SQL
