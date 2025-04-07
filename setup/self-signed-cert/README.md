# Debian 12 Self-Signed Certificate Setup

By: [16BitMiker](https://github.com/16BitMiker)

This Bash script automates the process of generating a self-signed SSL certificate on Debian 12.

## Features

- Installs OpenSSL
- Generates a 2048-bit RSA private key
- Creates a self-signed X.509 certificate valid for 365 days
- Interactive prompts for certificate details (country, region, city, etc.)
- Sets appropriate permissions for key and certificate files

## Usage

1. Run the script with sudo privileges
2. Follow the prompts to enter certificate details
3. The script will generate the key and certificate in `/etc/ssl/private/` and `/etc/ssl/certs/` respectively

## Note

This script is intended for development or testing environments. For production, use certificates from a trusted Certificate Authority.
