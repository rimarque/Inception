FROM debian:bullseye

EXPOSE 443

RUN     apt update && \
        apt install --no-install-recommends --no-install-suggests -y \
        nginx \
        openssl \
        && rm -rf /var/lib/apt/lists/*

#Define the ARG to use in the next commands. 
#At the final version, we'll have a .env file with all the variables,
#so you need to remove these declaration lines and keep the line 
#that call all variables.

ARG	CERT_FOLDER=/etc/nginx/certs/
ARG	CERTIFICATE=/etc/nginx/certs/certificate.crt
ARG	KEY=/etc/nginx/certs/certificate.key
ARG	COUNTRY=BR
ARG	STATE=BA
ARG	LOCALITY=Salvador
ARG	ORGANIZATION=42
ARG	UNIT=42
ARG	COMMON_NAME=login.42.fr

#Create the folder for the certificates and generate these. 
#It'll create a self-signed certificate that will be valid for 
#365 days. The subj flag is used to set the certificate information.
RUN	mkdir -p ${CERT_FOLDER} && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out ${CERTIFICATE} \
	-keyout ${KEY} \
	-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"

#Copy the configuration files to the container and complete the server.conf file 
#with the variables that will be passed by the .env file.
COPY	conf/nginx.conf	/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

RUN	echo "\tserver name ${COMMON_NAME};\n\
	\tssl_certificate ${CERTIFICATE};\n\
	\tssl_certificate_key ${KEY};\n\
	}" >> /etc/nginx/conf.d/server.conf

#Create the folder for the wordpress files and change its owner to www-data user.
RUN	mkdir -p /var/www/
RUN	chown -R www-data:www-data /var/www/

CMD	["nginx", "-g", "daemon off;"]