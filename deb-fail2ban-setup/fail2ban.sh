#!/usr/bin/bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ APT

# Update package list and install Fail2Ban
sudo apt update
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

# Check Fail2Ban status
sudo systemctl status fail2ban
sudo fail2ban-client status sshd

