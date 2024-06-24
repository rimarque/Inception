# Dockerfile responsible to build the image for the mariadb container

# speficies the base image for the Docker image - Debian with the Bullseye release (which is the one previous to the latest stable version)
# it sets up the starting point for building the Docker image (Debian 11)
# base image is needed because it provides the foundational environment upon which the custom Docker image will be built - OS, software packages, libraries and tools; docker images are built in layers and the base image is the initial layer
FROM debian:bullseye

#Indicates that this container will be listening on port 3306, as per mandated in the subject and
#because it's the convention for MySQL database (MariaDB is an open-source relational database management system (RDBMS) that is a fork of MySQL)
# the word EXPOSE doesn't publish the port, it only indicates which ports are intended to be published
# allows services running inside the container to be accessible outside of it; informs docker compose about the ports that need to be connected between containers
EXPOSE 3306

# Runs shell commands inside the Docker image
#Update the system and install the mariadb-server only. 
#The --no-install-recommends and --no-install-suggests flags are 
#used to avoid installing unnecessary packages. I used the the 
#commands with && to avoid creating unnecessary layers. 
#The rm -rf /var/lib/apt/lists/* is used to clean the apt cache and avoid unnecessary files in the image.
#executes on the container
RUN		apt-get update \
		&& apt-get install -y --no-install-recommends --no-install-suggests mariadb-server \
		&& rm -rf /var/lib/apt/lists/* \
		&& apt-get clean

# creates the directory /var/run/mysqld; -p: tells mkdir to create the directory and any necessary parent directories of they do not already exist; this directory is needed in the image, so that mariadb is able to store runtime files such as PID files and sockets
# the next line changes the ownership of the /var/run/mysqld and /var/lib/mysql to the mysql user and group; -R: means recursive, applies the ownership change to the directory and all its contents, so that the mysql has the necessary permissions to read, write, and execute files in this directory
# /var/lib/mysql is where mariadb stores its database files
# this part is needed because mariadb needs to access the runtime directory to create and manage files such as the socket file, or it may fail to start; running mariadb under mysql user instead of the root user adheres to the principle of least privilege, reducing the risk of security vulnerabilities, preventing unauthorized access
RUN mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql

#executes on the host (copys from the host (first argument) to the docker image (secund argument))
COPY 	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY	./tools/init.sh /bin/

# changes the permissions of the init.sh script file to make it executable inside the Docker image
RUN     chmod +x /bin/init.sh


# specifies the command to run when the container is started from this image
# init.sh: executes the initialization script
# mysqld_safe: starts mariadb in a safe mode, typically used to start mariadb within Docker containers 
CMD		["init.sh", "mysqld_safe"]