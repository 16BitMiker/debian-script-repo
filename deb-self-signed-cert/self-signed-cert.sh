#!/bin/bash
#
#          _nnnn_
#         dGGGGMMb
#        @p~qp~~qMb
#        M|@||@) M|
#        @,----.JM|
#       JS^\__/  qKL
#      dZP        qKRb
#     dZP          qKKb
#    fZP            SMMb
#    HZM            MMMM
#    FqM            MMMM
#  __| ".        |\dS"qML
#  |    `.       | `' \Zq
# _)      \.___.,|     .'
# \____   )MMMMMP|   .'
#      `-'       `--' 
#
# Debian 12 Self Signed Cert Setup
# By: 16BitMiker (v2024-10-28)
#
# ~~~~~~~~~~~~~~~~ BEGIN

# Enable debugging output
set -x

# Exit on error
set -e

# ~~~~~~~~~~~~~~~~ DEPENDENCIES

sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install openssl -y

# ~~~~~~~~~~~~~~~~ SETUP

sudo mkdir -p /etc/ssl/certs /etc/ssl/private
sudo openssl genrsa -out /etc/ssl/private/mykey.key 2048

# ~~~~~~~~~~~~~~~~ GENERATE CERT

perl -M'Term::ANSIColor qw(:constants)' -sE'

	map
	{
		printf qq|> %s%s: |, uc( $_ ), m~COUNTRY~i ? q| (2 Letter Code)| : q||; 
		chomp( $choice = <STDIN> );
 		$cmd =~ s~${_}~${choice}~;
		
	} qw( COUNTRY REGION CITY COMPANY DIVSION DOMAIN EMAIL );
	
	say q|> |, GREEN $cmd, RESET;
	system $cmd;
	
' -- -cmd='sudo openssl req -new -x509 -sha256 -key /etc/ssl/private/mykey.key -out /etc/ssl/certs/mycert.crt -days 365 -subj "/C=COUNTRY/ST=REGION/L=CITY/O=COMPANY/OU=DIVSION/CN=DOMAIN/emailAddress=EMAIL"'

# ~~~~~~~~~~~~~~~~ PERMISSIONS

sudo chmod 600 /etc/ssl/private/mykey.key
sudo chown root:root /etc/ssl/private/mykey.key
sudo chmod 644 /etc/ssl/certs/mycert.crt
sudo chown root:root /etc/ssl/certs/mycert.crt

# ~~~~~~~~~~~~~~~~ VALIDATION

sudo openssl x509 -in /etc/ssl/certs/mycert.crt -text -noout
