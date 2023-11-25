#! /bin/bash

# This script installs Apache

# sudo yum update -y

# sudo yum install -y httpd 

# # Start Apache service and enable it on system startup
# sudo systemctl start httpd
# sudo systemctl enable httpd

# Ensure to use this when connecting to your DB from EC2
# sudo dnf install mariadb105

# use the writers instance endpoint
# mysql -h <endpoint> -P 3306 -u <mymasteruser> -p

# !/bin/bash -xe
# STEP 1 - Setpassword & DB Variables

# DBName='aurora_db'
# DBUser='test'
# DBPassword='Extrajos58'
# DBRootPassword='Extrajos58'

# # STEP 2 - Install system software - including Web and DB

# sudo yum install -y wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel 

# # STEP 3 - Web and DB Servers Online - and set to startup


# systemctl enable httpd 
# systemctl enable mariadb 
# systemctl start httpd 
# systemctl start mariadb 

# # STEP 4 - Set Mariadb Root Password

# mysqladmin -u root password $DBRootPassword

# # STEP 5 - Install Wordpress

# wget http://wordpress.org/latest.tar.gz -P /var/www/html
# cd /var/www/html
# tar -zxvf latest.tar.gz 
# cp -rvf wordpress/* . 
# rm -R wordpress 
# rm latest.tar.gz

# # STEP 6 - Configure Wordpress

# cp ./wp-config-sample.php ./wp-config.php
# sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php 
# sed -i "s/'username_here'/'$DBUser'/g" wp-config.php 
# sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php 

# # Step 6a - permissions

# usermod -a -G apache ec2-user 
# chown -R ec2-user:apache /var/www 
# chmod 2775 /var/www 
# find /var/www -type d -exec chmod 2775 {} \; 
# find /var/www -type f -exec chmod 0664 {} \; 

# # STEP 7 Create Wordpress Database

# echo "CREATE DATABASE $DBName;" >> /tmp/db.setup 
# echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup 
# echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup 
# echo "FLUSH PRIVILEGES;" >> /tmp/db.setup 
# mysql -u root --password=$DBRootPassword < /tmp/db.setup
# sudo rm /tmp/db.setup

# # Create  Wordpress Database Backup
# mysqldump --user=root --password='Extrajos85' \
# --databases /tmp/db.setup --add-drop-database > db-backup.sql

# # Migration Code
# mysql --user=root --password='Extrajos58' \
# --host=<RDS Instance Database Endpoint Address> \
# < db-backup.sql

# # Migration Confirmation
# mysql --user=root --password='Extrajos58' \
# --host=<RDS Instance Database Endpoint Address> \
# db.setup