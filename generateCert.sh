#!/bin/bash

# Variables
CERT_DIR="./certs"
DAYS_VALID=365

# Function to generate certificate with SAN
generate_certificate() {
    local service_name=$1

    # Create directories for certs if they don't exist
    mkdir -p "$CERT_DIR/$service_name"

    # Generate a private key
    openssl genrsa -out "$CERT_DIR/$service_name/$service_name.key" 4096

    # Create a config file for SAN
    cat > "$CERT_DIR/$service_name/openssl-san.cnf" <<EOF
[ req ]
default_bits        = 4096
default_md          = sha256
default_keyfile     = $service_name.key
prompt              = no
encrypt_key         = no
distinguished_name  = req_distinguished_name
req_extensions      = req_ext

[ req_distinguished_name ]
countryName         = "US"
stateOrProvinceName = "California"
localityName        = "San Francisco"
organizationName    = "Your Organization"
commonName          = "$service_name"

[ req_ext ]
subjectAltName      = @alt_names

[ alt_names ]
DNS.1               = "$service_name"
# Additional SANs can be added here if necessary
EOF

    # Generate a CSR using the configuration file
    openssl req -new -key "$CERT_DIR/$service_name/$service_name.key" -out "$CERT_DIR/$service_name/$service_name.csr" -config "$CERT_DIR/$service_name/openssl-san.cnf"

    # Generate a self-signed certificate with SANs
    openssl x509 -req -days $DAYS_VALID -in "$CERT_DIR/$service_name/$service_name.csr" -signkey "$CERT_DIR/$service_name/$service_name.key" -out "$CERT_DIR/$service_name/$service_name.crt" -extensions req_ext -extfile "$CERT_DIR/$service_name/openssl-san.cnf"

    echo "$service_name certificate generated in $CERT_DIR/$service_name"
}

# Generate certificates for file and auth services
generate_certificate "file"
generate_certificate "auth"
