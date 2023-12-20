#! /bin/bash
sudo yum update -y
sudo yum install -y httpd php 
sudo yum install -y php-mysqli
sudo systemctl enable httpd
sudo systemctl start httpd

cd /var/www/html
aws s3 sync s3://solo-blogs/ .
#aws s3 sync s3://solo-blogs2/ .
#aws s3 sync s3://restartproject/ .


sudo sed -i "s/database_name_here/${DB}/" wp-config.php
sudo sed -i "s/username_here/${User}/" wp-config.php
sudo sed -i "s/password_here/${PW}/" wp-config.php
sudo sed -i "s/localhost/${host}/" wp-config.php

sudo service httpd restart


# #! /bin/bash
# # Install updates
# sudo yum update -y
# # Install Apache server
# sudo yum install -y httpd
# # Install MariaDB, PHP and necessary tools
# sudo yum install -y mariadb105-server php php-mysqlnd unzip
# # Start Apache server and enable it on system startup

# sudo systemctl start httpd
# sudo systemctl enable httpd

# # Start MariaDB service and enable it on system startup

# sudo systemctl start mariadb
# sudo systemctl enable mariadb

# # Set Mariadb root password

# mysqladmin -u root password $DBRootPassword

# cd /var/www/html
# aws s3 sync s3://restartproject/ .