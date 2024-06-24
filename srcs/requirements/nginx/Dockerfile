# Dockerfile-wordpress
FROM debian:bullseye

# Exposure of ports
EXPOSE 443

# Install necessary packages
RUN apt -y update && \
	apt install -y \
		nginx \
		openssl \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

# Copy the initialization script and NGINX configuration
COPY ./tools/init.sh /tmp/init.sh
COPY ./conf/server.conf /etc/nginx/sites-available/default

# Make the initialization script executable
RUN chmod +x /tmp/init.sh

# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/tmp/init.sh"]