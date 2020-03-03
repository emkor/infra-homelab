#!/usr/bin/env bash

set -e

echo "Generating self-signed certificates for Docker Registry"
mkdir -p ~/cert
# as Common Name / CN, type: *.cloud.local
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ~/cert/domain.key -x509 -days 1460 -out ~/cert/ca.crt