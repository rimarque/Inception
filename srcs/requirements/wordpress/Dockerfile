#To build a Docker image for WordPress starting from the debian:bullseye base image instead of the wordpress:latest image, 
#we need to set up additional components manually, such as a web server (like Apache or Nginx) and PHP, 
#because the debian:bullseye image doesn't include these by default.

FROM    debian:bullseye

EXPOSE  9000

#Set a variable to use in the next commands. 
#ARG is only avaliable in the build time
ARG     PHPPATH=/etc/php/7.4/fpm

RUN     apt update && \
        apt install --no-install-recommends --no-install-suggests -y \
        ca-certificates \
        php7.4-fpm \
        php7.4-mysql \
        wget \
        tar && \
        rm -rf /var/lib/apt/lists/* \
        && apt-get clean

RUN     service php7.4-fpm stop

#Copy the configuration file to the php folder
COPY	conf/www.conf ${PHPPATH}/pool.d/

#Change some values in the php config files -> APAGAR ISTO TUDO

#First command edits the php.ini file, disables cgi.fix_pathinfo.
#It finds the line ;cgi.fix_pathinfo=1 (which is commented out) and replaces it with cgi.fix_pathinfo=0 (uncommented and set to 0).
#Setting cgi.fix_pathinfo to 0 is a security measure to prevent PHP from interpreting paths as scripts, which can mitigate certain types of attacks.

#Second command edits the www.conf file in the pool.d directory,  changes PHP-FPM listen address.
#It changes the listen directive from a Unix socket file (/run/php/php$PHP_VERSION_ENV-fpm.sock) to a TCP port (9000).
#$PHP_VERSION_ENV is an environment variable representing the PHP version.

#Thirth command also edits the www.conf file, sets listen mode.
#It uncomment the listen.mode = 0660 directive, which sets the permissions for the socket file. 
#0660 means that the owner and group have read and write permissions, but others have no permissions.

#Fourth command edits the www.conf file, disables daemonization.
#It uncomment the daemonize = yes directive and changes it to daemonize = no.
#Setting daemonize to no means that PHP-FPM will not run as a background process. 
#This is useful when running PHP-FPM in a container or under a process manager.

#RUN	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini
	#sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf
	#sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
	#sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

#Download the wordpress CLI, change its permissions and move it to the bin/wp folder.       
RUN	wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && \
        mv wp-cli.phar /usr/local/bin/wp

#Create some folders needed by the wordpress files
RUN     mkdir -p /run/php/ && \
	    mkdir -p /var/run/php/ && \
	    mkdir -p /var/www/inception/

#change its owner to www-data user
RUN	    chown -R www-data:www-data /var/www/inception/

#Copy the wp-config.php and the setup script to the container and change its permissions
COPY    ./conf/wp-config.php /tmp/
COPY    ./tools/setup.sh /bin/

RUN     chmod -x /bin/setup.sh

CMD		["bash", "/bin/setup.sh", "php-fpm7.4", "--nodaemonize"]