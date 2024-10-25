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
# Debian 12 Fail2Ban Setup
# By: 16BitMiker (v2024-10-24)
# Run: curl -sSL https://wcw.sh/fail2ban.txt | bash
#
# ~~~~~~~~~~~~~~~~ BEGIN

# Enable debugging output
set -x

# Exit on error
set -e

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ APT

# Update package list
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y

# Upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Update package list and install Fail2Ban
sudo apt install fail2ban -y

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INIT

# Create a custom jail configuration for SSH
sudo tee /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime  = 86400  # 24 hours
findtime = 3600   # 1 hour
maxretry = 5      # 5 attempts
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = /var/log/auth.log
backend = systemd
EOF

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SYSTEMCTL

# Restart and enable Fail2Ban
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ STATUS

# Check Fail2Ban status (non-interactive)
sudo systemctl is-active --quiet fail2ban && echo "> Fail2Ban is active" || echo "> Fail2Ban is not active"

# Check Fail2Ban SSH jail status (non-interactive)
sudo fail2ban-client status sshd | grep "Status" || echo "> Failed to get SSH jail status"

set +x
set +e
