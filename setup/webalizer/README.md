# Webalizer Script

This script is designed to automate the process of installing and configuring Webalizer, a web server log file analysis program. It includes steps to install necessary packages, configure Webalizer, and perform some post-processing on the generated HTML files.

## Features

- Automatic installation of Webalizer and its dependencies.
- Configuration of Webalizer using environment variables.
- Post-processing of generated HTML files to anonymize IP addresses and add meta tags.
- Adjustment of file permissions for the output directory.

## Prerequisites

- A Unix-like operating system with a package manager (e.g., `apt`).
- Basic knowledge of Bash scripting and environment variables.

## Installation

1. Save the script to a file, for example, `webalizer_script.sh`.
2. Make the script executable:
   ```bash
   chmod +x webalizer_script.sh
   ```
3. Run the script:
   ```bash
   ./webalizer_script.sh
   ```

## Environment Variables

Before running the script, make sure to set the following environment variables:

- `WEBALIZER_CONF`: Path to the Webalizer configuration file.
- `WEBALIZER_OUTPUT`: Path to the output directory where Webalizer will store the generated HTML files.

Example:
```bash
export WEBALIZER_CONF="/path/to/webalizer.conf"
export WEBALIZER_OUTPUT="/path/to/output"
```

