#! /bin/bash

# This script installs Apache

sudo yum update -y

sudo yum install -y httpd 

# Start Apache service and enable it on system startup
sudo systemctl start httpd
sudo systemctl enable httpd

# Ensure to use this when connecting to your DB from EC2
# sudo yum install mariadb
# use the writers instance endpoint
# mysql -h <endpoint> -P 3306 -u <mymasteruser> -p