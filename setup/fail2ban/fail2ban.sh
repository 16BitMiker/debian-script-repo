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

# Don't exit on error, but log it
set +e

log_error() {
    echo "ERROR: $1" >&2
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REMOVAL

echo "Checking if Fail2Ban is installed..."
if dpkg -s fail2ban &> /dev/null; then
    echo "Fail2Ban is installed. Proceeding with removal..."
    
    echo "Stopping and disabling Fail2Ban..."
    sudo systemctl stop fail2ban || log_error "Failed to stop Fail2Ban"
    sudo systemctl disable fail2ban || log_error "Failed to disable Fail2Ban"

    echo "Removing Fail2Ban..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get purge --auto-remove fail2ban -y || log_error "Failed to purge Fail2Ban"
else
    echo "Fail2Ban is not installed. Skipping removal steps."
fi

echo "Removing any remaining Fail2Ban files..."
sudo rm -rf /etc/fail2ban 2>/dev/null || log_error "Failed to remove /etc/fail2ban"
sudo rm -f /var/lib/fail2ban/fail2ban.sqlite3 2>/dev/null || log_error "Failed to remove fail2ban.sqlite3"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INSTALL

echo "Updating package lists..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y || log_error "Failed to update package lists"

echo "Installing Fail2Ban and rsyslog..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install fail2ban rsyslog -y || log_error "Failed to install Fail2Ban and rsyslog"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CONFIGURATION

echo "Configuring Fail2Ban..."
sudo mkdir -p /etc/fail2ban || log_error "Failed to create /etc/fail2ban directory"
sudo tee /etc/fail2ban/jail.local <<EOF || log_error "Failed to create jail.local"
[DEFAULT]
bantime  = 86400
findtime = 3600
maxretry = 5
ignoreip = 127.0.0.1/8 ::1
backend = systemd

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
EOF

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SYSTEMCTL

echo "Ensuring rsyslog is running..."
sudo systemctl start rsyslog || log_error "Failed to start rsyslog"
sudo systemctl enable rsyslog || log_error "Failed to enable rsyslog"

echo "Starting and enabling Fail2Ban..."
sudo systemctl start fail2ban || log_error "Failed to start Fail2Ban"
sudo systemctl enable fail2ban || log_error "Failed to enable Fail2Ban"

# Wait for Fail2Ban to fully start
sleep 5

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ STATUS

echo "Fail2Ban Status:"
sudo systemctl status fail2ban --no-pager || log_error "Failed to get Fail2Ban status"

echo "Fail2Ban SSH Jail Status:"
sudo fail2ban-client status sshd || log_error "Failed to get SSH jail status"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ LOGS

echo "Recent Fail2Ban Logs:"
sudo journalctl -u fail2ban -n 50 --no-pager || log_error "Failed to retrieve Fail2Ban logs"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TROUBLESHOOTING

echo "Checking Fail2Ban configuration:"
sudo fail2ban-client -t || log_error "Fail2Ban configuration test failed"

echo "Checking if auth.log exists:"
ls -l /var/log/auth.log || log_error "auth.log not found"

echo "Checking permissions of Fail2Ban socket:"
ls -l /var/run/fail2ban/fail2ban.sock || log_error "Fail2Ban socket not found"

echo "Checking rsyslog status:"
sudo systemctl status rsyslog --no-pager || log_error "Failed to get rsyslog status"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END

set +x

echo "Fail2Ban installation and configuration complete."
echo "Please review any ERROR messages above."
