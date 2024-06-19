!/bin/bash
# this script run in the building container
# it creates start the mariadb service and create the database and users according to the .env file
# at the end, exec $@ run the next CMD in the Dockerfile.
# In this case: "mysqld_safe" that restart the mariadb service

#These variables will be moved to .env and changed
DB_NAME=thedatabase
DB_USER=theuser
DB_PASSWORD=abc
DB_PASS_ROOT=123

#Start the database server
service mariadb start

#Create the database and the users with its passwords and permissions.
#starts the mariadb command-line client (-u root specifies the user as root. 
#-v is for verbose outpus - prints more info).
# The mariadb client will execute all commands enclosed between << EOF and EOF.
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
EOF

sleep 5

service mariadb stop

exec $@