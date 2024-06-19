#!/bin/bash

certify_path="/etc/ssl/private/$DOMAIN"

openssl req -x509 -nodes -out $certify_path.csr -keyout $certify_path.key \
            -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/$UNIT=42/CN=$DOMAIN/UID=$DOMAIN_NAME"

sed -i "s/\$DOMAIN/$DOMAIN/g" /etc/nginx/sites-available/default

nginx -t

nginx -g "daemon off;"