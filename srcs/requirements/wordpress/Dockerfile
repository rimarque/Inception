#To build a Docker image for WordPress starting from the debian:bullseye base image instead of the wordpress:latest image, 
#we need to set up additional components manually, such as a web server (like Apache or Nginx) and PHP, 
#because the debian:bullseye image doesn't include these by default.

#In this image we won't set up the web server parts, because that will be handled by nginx
#This image provides a stable and minimal Debian environment.
FROM    debian:bullseye

#Exposing port 9000 (EXPOSE 9000) allows other containers or services to connect to PHP-FPM running inside this container.
EXPOSE  9000

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

#Copy the configuration file to the container's php folder 
#Ensures that PHP-FPM is configured correctly. This step is crucial for tuning PHP-FPM’s behavior and settings
#The www.conf file is part of the PHP-FPM configuration and is typically located in the pool.d directory (or similar) within the PHP installation directory.
COPY	conf/www.conf /etc/php/7.4/fpm/pool.d/

#Download the wordpress CLI (Command-line interface), gives it executing permissions and moves it to the bin/wp folder.       
#Allows for command-line management of WordPress installations within the container.
RUN	wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && \
        mv wp-cli.phar /usr/local/bin/wp

#Ensures that required directories exist for PHP-FPM and WordPress operations
#and changes its owner to www-data user, ensuring that WordPress files can be read and written by the PHP-FPM process securely.
#The www-data user and group are commonly used by web servers (like Nginx) to run web applications. 
#Changing ownership to www-data ensures that the web server has the necessary permissions to read, write, and execute files in the specified directory.
RUN     mkdir -p /run/php/ /var/run/php/ /var/www/inception/ \
        && chown -R www-data:www-data /var/www/inception/

#Prepares the container for configuring and running WordPress upon startup.
#Copy the wp-config.php and the initializaion script to the container
COPY    ./conf/wp-config.php /var/www/inception/
COPY    ./tools/init.sh /bin/

#Give the initialization script permisssion to executed by user
RUN     chmod +x /bin/init.sh

#The CMD instruction specifies the command to run when the container starts. 
#Running /bin/init.sh php-fpm7.4 --nodaemonize initiates the init script (init.sh)
#which configures WordPress and starts PHP-FPM in non-daemon mode.
#Non-daemon mode means that a service or application runs in the foreground, 
#actively interacting with the terminal or command line where it was started, 
#instead of running as a background process. 
#This is often used for debugging or when you need to see real-time output and logs directly in your terminal.
#Non-Daemon Mode: The service runs in the foreground, useful for debugging and monitoring.
#Daemon Mode: The service runs in the background, typical for production services.
#In Docker, running in non-daemon mode is standard practice to KEEP THE CONTAINER RUNNING and provide real-time logs.
CMD		["init.sh", "php-fpm7.4", "--nodaemonize"]
