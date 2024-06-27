#!/bin/bash

CERTIFY_DIR="/etc/ssl/private"

# Create the directory if it doesn't exist
mkdir -p $CERTIFY_DIR

# Generate the SSL certificate and key:
# SSL certificate is a way to create a more secure connection by encrypting the information transmitted between the client and the server where the certificate is installed.

# openssl: command-line tool for the OpenSSL library, which provides various cryptographic operations
# req: specifies that we want to use the "certificate request and certificate generating utility" in OpenSSL. This utility can be used to create a certificate signing request (CSR) or, in this case, a self-signed certificate.
# using a self-signed certificate is primarily useful in situations where you need to encrypt data over HTTPS (HTTP Secure) but don't require third-party validation or where setting up a full certificate authority (CA) infrastructure isn't feasible or necessary
# -x509: to generate a self-signed certificate instead of a certificate signing request (CSR); the X.509 standard defines the format of public key certificates.
# -nodes: no DES (Data Encryption Standard): the key will not be encrypted with a passphrase, which is practical for automated scripts.
# -days 365: the validity period of the certificate
# -newkey rsa:2048: generates a new private key using the RSA algorithm with a key size of 2048 bits
# -keyout $certify_path.key: specifies the filename where the private key will be saved
# -out $certify_path.crt: specifies the filename where the certificate will be saved
# -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$DOMAIN: sets up the details in the certificate
# these components are crucial in certificate validation. When a client (such as a web browser) connects to a server secured with SSL/TLS, it verifies the details in the certificate to ensure it's connecting to the intended server
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $CERTIFY_DIR/$DOMAIN.key -out $CERTIFY_DIR/$DOMAIN.crt \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$DOMAIN"

# Replace the placeholder in the NGINX configuration file with the actual domain name
sed -i "s/\$DOMAIN/$DOMAIN/g" /etc/nginx/sites-available/default

# Start NGINX in non-daemon mode
nginx -g 'daemon off;'