# Numen Installer

## Overview

Numen is a powerful tool designed for local voice 2 text control over your system. This installer script simplifies the installation process by automatically setting up all necessary dependencies and configurations on Debian-based systems.

## Features

- Automated installation of dependencies
- Configuration of Python virtual environments
- Easy setup of command aliases for managing Numen
- Compatibility with multiple Python versions

## Prerequisites

Before running the installer, ensure you have the following:

- A Debian-based operating system (e.g., Ubuntu, Debian)
- Internet access for downloading packages and repositories
- Sudo privileges to install software

## Installation

To install Numen, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://git.sr.ht/~geb/numen
   cd numen
   ```

2. **Run the Installer Script**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   This will perform the following:
   - Update and upgrade your system's packages.
   - Set up Python virtual environments with the necessary dependencies.
   - Clone and install Numen and its components.
   - Create command aliases for starting and stopping Numen.

## Usage

After installation, you can manage Numen using the following commands:

- **Start Numen**:
  ```bash
  numb
  ```

- **Stop Numen**:
  ```bash
  numx
  ```

To deactivate the Python virtual environment, simply type:
```bash
deactivate
```

## Configuration

The installer automatically adds aliases to your `~/.bashrc` for easy access. You can customize these aliases as needed.

## Troubleshooting

- If you encounter issues during installation, ensure that your system meets the prerequisites.
- Check for any error messages in the terminal for guidance.
- If a reboot is required after installation, the script will prompt you. You can also do it manually using:
  ```bash
  sudo reboot
  ```
