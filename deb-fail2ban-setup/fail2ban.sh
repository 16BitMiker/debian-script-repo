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
# Debian 12 Fail2Ban Clean Install
# By: 16BitMiker (v2024-10-27)
#
# ~~~~~~~~~~~~~~~~ BEGIN

# Enable debugging output
set -x

# Exit on error
set -e

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REMOVAL

echo "Stopping and disabling Fail2Ban..."
sudo systemctl stop fail2ban || true
sudo systemctl disable fail2ban || true

echo "Removing Fail2Ban..."
sudo apt-get purge --auto-remove fail2ban -y

echo "Removing any remaining Fail2Ban files..."
sudo rm -rf /etc/fail2ban
sudo rm -f /var/lib/fail2ban/fail2ban.sqlite3

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INSTALL

echo "Updating package lists..."
sudo apt-get update

echo "Installing Fail2Ban and rsyslog..."
sudo apt-get install fail2ban rsyslog -y

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CONFIGURATION

echo "Configuring Fail2Ban..."
sudo tee /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime  = 86400  # 24 hours
findtime = 3600   # 1 hour
maxretry = 5      # 5 attempts
ignoreip = 127.0.0.1/8 ::1
backend = systemd
allowipv6 = auto

[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = /var/log/auth.log
backend = systemd
EOF

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SYSTEMCTL

echo "Ensuring rsyslog is running..."
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

echo "Starting and enabling Fail2Ban..."
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ STATUS

echo "Fail2Ban Status:"
sudo systemctl status fail2ban

echo "Fail2Ban SSH Jail Status:"
sudo fail2ban-client status sshd || echo "> Failed to get SSH jail status"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ LOGS

echo "Recent Fail2Ban Logs:"
sudo journalctl -u fail2ban -n 50 --no-pager

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TROUBLESHOOTING

echo "Checking Fail2Ban configuration:"
sudo fail2ban-client -t

echo "Checking if auth.log exists:"
ls -l /var/log/auth.log || echo "auth.log not found"

echo "Checking permissions of Fail2Ban socket:"
ls -l /var/run/fail2ban/fail2ban.sock || echo "Fail2Ban socket not found"

echo "Checking rsyslog status:"
sudo systemctl status rsyslog

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END

set +x
set +e

echo "Fail2Ban installation and configuration complete."
