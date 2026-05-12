#!/bin/bash
set -e          # Exit immediately if any command fails (recommended)
echo "=== Starting VM init on $(hostname) ==="

# base
sudo apt update
sudo apt install -y htop vim fail2ban ufw rsync iputils-ping less ca-certificates curl cron

# install docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# finish base
sudo apt upgrade -y

# config firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 10.0.0.0/24
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

# config fail2ban
sudo cp /etc/fail2ban/jail.d/defaults-debian.conf /etc/fail2ban/jail.d/defaults-debian.conf.bak.$(date +%Y%m%d-%H%M%S)
sudo bash -c '
  FILE="/etc/fail2ban/jail.d/defaults-debian.conf"
  if ! grep -qE "^[[:space:]]*(bantime|maxretry)[[:space:]]*=[[:space:]]*" "$FILE"; then
    echo -e "\nbantime = 24h\nmaxretry = 3" | tee -a "$FILE" > /dev/null
    echo "Done: Added bantime and maxretry to [sshd] section."
  else
    echo "Error: Settings for bantime or maxretry already exist in the file (skipped)."
  fi
'

echo "=== VM init successfull ==="

exit 0
