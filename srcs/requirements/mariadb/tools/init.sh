#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations
# this script integrates with the container's CMD instruction to run the main application process after the initialization steps are completed, ensuring that the application starts in a properly configured state

# this line, if uncommented, enables the debug mode, making the script print each command executing it and exit if any of it returns a non-zero status
# set -ex # print commands & exit on error (debug mode)

# this script run in the building container
# it creates start the mariadb service and create the database and users according to the .env file
# at the end, exec $@ run the next CMD in the Dockerfile.
# In this case: "mysqld_safe" that restart the mariadb service

#These variables will be moved to .env and changed
#DB_NAME=thedatabase
#DB_USER=theuser
#DB_PASSWORD=abc
#DB_PASS_ROOT=123

# starts the mariadb within the container and ensures it is running so that the subsequent commands can interact with the database
service mariadb start

# Wait for the service to start properly
sleep 5

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

# pauses execution of the script, so that it allows time for the DB operations initiatedi by the mariadb client to complete before stopping the service
sleep 5

# stops the mariadb service; it is a good practice to stop services after initial setup to ensure they can restart cleanly when the container starts again
service mariadb stop

# executes the command passed to the script as argument (specified by CMD). Replaces the current shell process with the specified command, which is efficient and ensures that signals are correctly passed to the main process
exec $@