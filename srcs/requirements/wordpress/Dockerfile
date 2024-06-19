#To build a Docker image for WordPress starting from the debian:bullseye base image instead of the wordpress:latest image, 
#we need to set up additional components manually, such as a web server (like Apache or Nginx) and PHP, 
#because the debian:bullseye image doesn't include these by default.

#In this image we won't set up the web server parts, because that will be handled by nginx
#This image provides a stable and minimal Debian environment.
FROM    debian:bullseye

#Exposing port 9000 (EXPOSE 9000) allows other containers or services to connect to PHP-FPM running inside this container.
EXPOSE  9000

#Set a variable to use in the next commands. 
#ARG is only avaliable in the build time
ARG     PHPPATH=/etc/php/7.4/fpm

# Install necessary packages: PHP and dependencies

#ca-certificates: this package is used to manage SSL certificates. It's generally good practice to have it installed.
#php7.4-fpm: this package provides PHP-FPM, which is essential for serving PHP files and running PHP applications like WordPress.
#php7.4-mysql: this package provides MySQL support for PHP, allowing PHP to communicate with MySQL databases. It's necessary for WordPress to interact with mariadb.
#wget: this utility is used for downloading files from the web via HTTP, HTTPS, and FTP protocols. In this Dockerfile, it's used to download WordPress and potentially other resources.
#tar: this utility is used for archiving files. In this Dockerfile, it's used to extract the downloaded WordPress archive (latest.tar.gz).
#rm -rf /var/lib/apt/lists/* && apt-get clean: cleaning Up: After installing packages, it's good practice to clean up the package cache to reduce the size of the Docker image.

#EXTRA INFORMATION
#php: installing version 7.4; FPM = FastCGI Process Manager;
#CGI (Common Gateway Interface) is a standard protocol that defines how web servers communicate with external programs or scripts to generate 
#dynamic web content or perform other server-side tasks.
#FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation that offers several advantages over and more efficiency then traditional CGI-based methods
RUN     apt update && apt install -y \
        ca-certificates \
        php7.4-fpm \
        php7.4-mysql \
        wget \
        tar && \
        rm -rf /var/lib/apt/lists/* \
        && apt-get clean

#May noyt be necessary, try without!!!!
RUN     service php7.4-fpm stop

#Copy the configuration file to the container's php folder 
#Ensures that PHP-FPM is configured correctly. This step is crucial for tuning PHP-FPM’s behavior and settings
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

#Download the wordpress CLI (Command-line interface), change its permissions and move it to the bin/wp folder.       
#Allows for command-line management of WordPress installations within the container.
RUN	wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && \
        mv wp-cli.phar /usr/local/bin/wp

#Ensures that required directories exist for PHP-FPM and WordPress operations
#and changes its owner to www-data user, ensuring that WordPress files can be read and written by the PHP-FPM process securely.
RUN     mkdir -p /run/php/ /var/run/php/ /var/www/inception/ \
        && chown -R www-data:www-data /var/www/inception/

#Copy the wp-config.php and the setup script to the container and change its permissions
#Prepares the container for configuring and running WordPress upon startup.
COPY    ./conf/wp-config.php /tmp/
COPY    ./tools/setup.sh /bin/

RUN     chmod -x /bin/setup.sh

#The CMD instruction specifies the command to run when the container starts. 
#Running /bin/setup.sh php-fpm7.4 --nodaemonize initiates the setup script (setup.sh)
#which likely configures WordPress and starts PHP-FPM in non-daemon mode.
#EXPLORE DAEMON MODE!!!
CMD		["bash", "/bin/setup.sh", "php-fpm7.4", "--nodaemonize"]
