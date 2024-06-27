FROM debian:bullseye

EXPOSE 443

RUN apt -y update && \
	apt install -y \
		nginx \
		openssl \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

COPY ./tools/init.sh /tmp/init.sh
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

RUN chmod +x /tmp/init.sh

# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/tmp/init.sh"]