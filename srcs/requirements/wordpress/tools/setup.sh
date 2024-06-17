#Change the owner of the wordpress files to www-data user.
chown -R www-data:www-data /var/www/inception/



#Move the wp-config.php file to the wordpress folder if it isn't there.
if [ ! -f /var/www/inception/wp-config.php ]; then
	mv /tmp/wp-config.php /var/www/inception/
fi

#move to .env file
WP_URL=login.42.fr
WP_TITLE=Inception
WP_ADMIN_USER=theroot
WP_ADMIN_PASSWORD=123
WP_ADMIN_EMAIL=theroot@123.com
WP_USER=theuser
WP_PASSWORD=abc
WP_EMAIL=theuser@123.com
WP_ROLE=editor

#Download the wordpress files
sleep 10
wp --allow-root --path="/var/www/inception/" core download || true

#If the wordpress files aren't there, create install wordpress and 
#set it, if not move foward
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

wp --allow-root --path="/var/www/inception/" theme install raft --activate 

exec $@