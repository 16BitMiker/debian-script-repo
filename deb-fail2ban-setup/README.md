# Fail2Ban Server Security Setup

*By: [16BitMiker](https://github.com/16BitMiker)* 

## Overview

Bash script for setting up and configuring Fail2Ban on a Linux server. Fail2Ban is a powerful intrusion prevention tool that enhances server security by protecting against brute-force attacks and other malicious activities.

## Features

- Automatic installation of Fail2Ban
- Custom configuration for SSH protection
- Enhanced security settings:
  - 24-hour ban time for offending IPs
  - 1-hour window to detect suspicious activity
  - 5 maximum retry attempts before banning
- Automatic startup configuration
- Status check commands included

## Benefits

- Significantly reduces the risk of successful brute-force attacks
- Decreases log clutter, making it easier to identify genuine issues
- Customizable to suit specific security needs
- Can protect various services beyond just SSH

## Script Functionality

The script performs the following actions:

1. Updates the package list and installs Fail2Ban
2. Creates a custom jail configuration for SSH
3. Sets up Fail2Ban to start automatically on system boot
4. Restarts the Fail2Ban service to apply new settings
5. Checks the status of Fail2Ban and the SSH-specific jail

## Configuration Details

The custom configuration in this script:

- Sets the ban time to 24 hours
- Defines a 1-hour window to detect suspicious activity
- Allows 5 retry attempts before banning an IP
- Ignores localhost IP addresses

## Important Note

This script is designed to enhance server security, but it should be part of a comprehensive security strategy. Always keep your system updated and follow best practices for server hardening.

