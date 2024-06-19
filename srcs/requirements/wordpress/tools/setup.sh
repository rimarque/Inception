# this script runs in the building container
# it changes the ownership of the /var/www/inception/ folder to www-data user
# then ensures that the wp-config.php file is in the /var/www/inception/ folder
# then it downloads the wordpress core files if they are not already there
# then it installs wordpress if it is not already installed
# and set the admin user and password if they are not already set
# this variables are set in the .env file
# the penultimate line downloads and activates the raft theme that I liked most
# at the end, exec $@ run the next CMD in the Dockerfile.
# In this case: starts the php-fpm7.4 server in the foreground

# set -ex # print commands & exit on error (debug mode)

WP_URL=rimarque.42.fr
WP_TITLE=Inception
WP_ADMIN_USER=wpadmin
WP_ADMIN_PASSWORD=abc
WP_ADMIN_EMAIL=wpadmin@123.com
WP_USER=wpuser
WP_PASSWORD=abc
WP_EMAIL=wpuser@123.com
WP_ROLE=editor

chown -R www-data:www-data /var/www/inception/

if [ ! -f "/var/www/inception/wp-config.php" ]; then
   cp /tmp/wp-config.php /var/www/inception/
fi

sleep 10

wp      --allow-root --path="/var/www/inception/" core download || true

if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER;
then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;

#Tirar esta linha e ver o que acontece
wp --allow-root --path="/var/www/inception/" theme install raft --activate 

exec $@