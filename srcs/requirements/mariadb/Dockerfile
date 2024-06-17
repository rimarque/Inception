
#The subject informs that we need to use the 
#penultimate stable version of debian or alpine
#Debian 11 ("bullseye") — current "oldstable" release 
FROM debian:bullseye

#Indicates that this container will be 
#listening on port 3306, 
#as per mandated in the subject
#because it's the convention for MySQL database
#MariaDB is an open-source relational database management system (RDBMS) that is a fork of MySQL
EXPOSE 3306

#Update the system and install the mariadb-server only. 
#The --no-install-recommends and --no-install-suggests flags are 
#used to avoid installing unnecessary packages. I used the the 
#commands with && to avoid creating unnecessary layers. 
#The rm -rf /var/lib/apt/lists/* is used to clean the apt cache and avoid unnecessary files in the image.
#executes on the container
RUN		apt-get update \
		&& apt-get install -y --no-install-recommends --no-install-suggests mariadb-server \
		&& rm -rf /var/lib/apt/lists/*

#executes on the host (copys from the host (first argument) to the container (secund argument))
COPY 	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY	./tools/setup.sh /bin/
RUN     chmod +x /bin/setup.sh


#The comand executes as an entry point (starts the app)
#The instruction that is to be executed when the container starts
#, it can only be one
#This hapens when I run the image
#Execute the setup script then start the database server. 
CMD		["bash","/bin/setup.sh", "mysqld_safe"]