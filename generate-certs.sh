#!/bin/bash

CERT_DIR="./certs"
CERT_NAME="mycert"
DAYS_VALID=365

mkdir -p $CERT_DIR

# Generate a private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout $CERT_DIR/${CERT_NAME}.key -out $CERT_DIR/${CERT_NAME}.crt -days $DAYS_VALID -nodes -subj "/CN=localhost"

openssl req -new -newkey rsa:4096 -nodes -keyout auth.key -out auth.csr -subj "/CN=auth"
openssl x509 -req -days 365 -in auth.csr -signkey auth.key -out auth.crt

openssl req -new -newkey rsa:4096 -nodes -keyout file.key -out file.csr -subj "/CN=file"
openssl x509 -req -days 365 -in file.csr -signkey file.key -out file.crt


echo "Certificates generated in $CERT_DIR:"
ls -l $CERT_DIR

