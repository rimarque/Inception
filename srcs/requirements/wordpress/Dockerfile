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
        rm -rf /var/lib/apt/lists/*

RUN     service php7.4-fpm stop

#Copy the configuration file to the php folder
COPY	conf/www.conf ${PHPPATH}/pool.d/

#Change some values in the php config files
RUN		sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
		sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

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