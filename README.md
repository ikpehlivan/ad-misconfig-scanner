# \# AD Misconfiguration Scanner

# 

# Lightweight Active Directory enumeration \& misconfiguration detection tool for authorized security assessments.

# 

# \---

# 

# \## Overview

# 

# \*\*AD Misconfig Scanner\*\* is a Bash-based automation script designed to quickly identify common Active Directory weaknesses such as:

# 

# \* Service accounts (SPN exposure)

# \* AS-REP roastable users (no pre-authentication)

# \* SMB shares and permissions

# \* RID-based user enumeration

# 

# Built for \*\*speed, simplicity, and practical pentest usage\*\*.

# 

# \---

# 

# \## Features

# 

# \* LDAP SPN enumeration

# \* Kerberos AS-REP roasting detection

# \* SMB enumeration (shares, users, policies)

# \* RID brute-force discovery

# \* NetExec integration

# \* JSON + HTML reporting

# \* Clean and structured output

# 

# \---

# 

# \## Installation

# 

# ```bash

# git clone https://github.com/yourusername/ad-misconfig-scanner.git

# cd ad-misconfig-scanner

# chmod +x ad-misconfig-scanner.sh

# ```

# 

# \### Requirements

# 

# \* Linux (Kali / Ubuntu recommended)

# \* Bash 4+

# 

# Install dependencies:

# 

# ```bash

# sudo apt update \&\& sudo apt install -y ldap-utils python3-pip

# pip3 install impacket

# pipx install netexec

# pipx install enum4linux-ng

# ```

# 

# \---

# 

# \## Usage

# 

# ```bash

# ./ad-misconfig-scanner.sh \\

# \-t <target\_ip> \\

# \-d <domain> \\

# \-u <username> \\

# \-p <password>

# ```

# 

# \### Example

# 

# ```bash

# ./ad-misconfig-scanner.sh -t 192.168.1.10 -d corp.local -u pentest -p password123

# ```

# 

# \---

# 

# \## Output

# 

# Results are saved in a timestamped directory:

# 

# ```

# scan\_XXXXXXXX/

# ├── ldap\_spn.txt

# ├── asrep.txt

# ├── asrep\_hashes.txt

# ├── smb\_enum.txt

# ├── nxc\_shares.txt

# ├── rid.txt

# ├── report.json

# └── report.html

# ```

# 

# \---

# 

# \## Report Example

# 

# \* SPN Accounts: 12

# \* AS-REP Roastable Users: 3

# 

# \---

# 

# \## Use Cases

# 

# \* Internal pentest engagements

# \* Active Directory lab environments

# \* Red team reconnaissance

# \* Security misconfiguration audits

# 

# \---

# 

# \## Roadmap

# 

# \* \[ ] Anonymous scan mode

# \* \[ ] BloodHound export

# \* \[ ] Multi-target scanning

# \* \[ ] Plugin-based architecture

# \* \[ ] Parallel execution

# 

# \---

# 

# \## Disclaimer

# 

# This tool is intended for \*\*authorized security testing and educational purposes only\*\*.

# 

# The user is responsible for complying with all applicable laws and regulations.

# Do not use this tool on systems you do not own or have explicit permission to test.

# 

# \---

# 

# \## Author

# 

# ikpehlivan

# 

# \---



