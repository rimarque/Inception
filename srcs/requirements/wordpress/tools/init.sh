#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations
# this script integrates with the container's CMD instruction to run the main application process after the initialization steps are completed, ensuring that the application starts in a properly configured state

# this line, if uncommented, enables the debug mode, making the script print each command executing it and exit if any of it returns a non-zero status
# set -ex # print commands & exit on error (debug mode)

#WP_URL=rimarque.42.fr
#WP_TITLE=Inception
#WP_ADMIN_USER=wpadmin
#WP_ADMIN_PASSWORD=abc
#WP_ADMIN_EMAIL=wpadmin@123.com
#WP_USER=wpuser
#WP_PASSWORD=abc
#WP_EMAIL=wpuser@123.com
#WP_ROLE=editor

# Checks if wp-config.php is present
if [ ! -f /var/www/inception/wp-config.php ]; then
    echo "WordPress configuration file not found!"
    exit 1
fi

#Ensures other services (like databases) are fully initialized before attempting to install or configure WordPress.
sleep 10

#Using the WP-CLI (WordPress Command Line Interface) to download and install wordpress,
#setting some important variables, as the URL, the title, the admin user information and a not-admin user with the role of editor

# Download WordPress core files if not already downloaded
#The '|| true' ensures that if the download fails (e.g., files are already present), the script does not stop.
wp --allow-root --path="/var/www/inception/" core download || true

# Installs wordpress if it is not already installed
# Sets the admin user and password if they are not already set
if ! wp --allow-root --path="/var/www/inception/" core is-installed ; then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

#If user does does not exist, create user
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER ; then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;

# Execute the command passed to the script
exec $@