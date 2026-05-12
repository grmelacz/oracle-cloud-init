# Automatic Oracle Cloud Ubuntu VMs basic config

How to use the script:

```
$ curl -fsSL https://raw.githubusercontent.com/grmelacz/oracle-cloud-init/refs/heads/main/oracle-init.sh | bash
```

The script does use use non-interactive commands (e.g. for updating packages), however you'll still need to enter your password when asked as most of the commands require root access. Do not run the script as root directly.

## What the script does
1. Installs various basic utils: htop, vim, fail2ban, ufw, rsync, ping, less, ca-certificates, curl and cron.
2. Adds Docker APT sources and installs Docker.
3. Sets up basic UFW rules enabling SSH, HTTP and HTTPS.
4. Upgrades all packages.
5. Sets up basic fail2ban rules for ssh.

