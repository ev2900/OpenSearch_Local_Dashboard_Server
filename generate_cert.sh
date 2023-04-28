#!/usr/bin/bash
#
# Generates a self signed certficate using OpenSSL
#
#

DOCKER_COMPOSE_FILE=docker-compose-ssl.yaml

### prechecks
if [ ! -f $DOCKER_COMPOSE_FILE ] 
then
    echo "$DOCKER_COMPOSE_FILE not found. Aborting..."
    exit 1
fi
if ! hash openssl 2>/dev/null 
then
    echo "OpenSSL not found. Aborting..."
    exit 1
fi

### Make a certs directory
mkdir -p certs
cd certs

### Create a private key for your certifying authority
openssl genrsa -out root-ca-key.pem 2048  2>/dev/null

### Generate a self-signed certificate
openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem -days 730 -subj "/C=XX/L=Default City/OU=Default Company Ltd/" 2>/dev/null

### Create a private key for your certificate
openssl genrsa -out node1-key.pem 2048 2>/dev/null

### Create a certificate request using the key
openssl req -new -key node1-key.pem -out node1.csr -subj "/C=XX/L=Default City/OU=Default Company Ltd/" 2>/dev/null

### Create a SAN extension file that describes the hostname used by the dashboard server. This may be necessary for some browsers. We will use 'localhost'.
echo 'subjectAltName=DNS:localhost' > node1.ext

### Issue a certificate using our CA
openssl x509 -req -in node1.csr -CA root-ca.pem -CAkey root-ca-key.pem -set_serial 01 -sha256 -out node1.pem -days 730 -extfile node1.ext 2>/dev/null

### Clean up
unlink node1.csr
unlink node1.ext
cd ..

if [ ! -f certs/root-ca.pem ] || [ ! -f certs/node1.pem ] || [ ! -f certs/node1-key.pem ] 
then
    echo "ERROR: Certificates could not be generated."
else
    ### Update our docker-compose
    sed -i -e 's/<CA_certificate>/root-ca.pem/g' -e 's/<node_certificate>/node1.pem/g' -e 's/<node_certificate_key>/node1-key.pem/g' -e "s|<path_to_folder_w_certs_keys>|$PWD\/certs|g" $DOCKER_COMPOSE_FILE 

    echo "Certificates and configuration updated."
fi

