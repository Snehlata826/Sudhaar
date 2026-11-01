#!/bin/bash
# First-boot setup for an Ubuntu 24.04 Lightsail server (2 GB RAM or more). Runs as root. Progress: /var/log/sudhaar-setup.log
set -eux
exec >>/var/log/sudhaar-setup.log 2>&1

# The torch install is memory-hungry on a 2 GB server
if [ ! -f /swapfile ]; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >>/etc/fstab
fi

apt-get update
apt-get install -y docker.io docker-compose-v2 git curl
systemctl enable --now docker

[ -d /opt/sudhaar ] || git clone https://github.com/Snehlata826/Sudhaar.git /opt/sudhaar

# Rebuilds the HTTPS hostname from the public IP on every boot, so attaching a static IP needs only a reboot
cat >/usr/local/bin/sudhaar-up <<'EOF'
#!/bin/bash
set -e
cd /opt/sudhaar
IP=$(curl -fsS --retry 5 https://checkip.amazonaws.com)
echo "SITE=${IP//./-}.sslip.io" >site.env
docker compose --env-file site.env -f compose.yaml -f deploy/compose.aws.yaml up -d --build
EOF
chmod +x /usr/local/bin/sudhaar-up

cat >/etc/systemd/system/sudhaar.service <<'EOF'
[Unit]
Description=Sudhaar containers
After=network-online.target docker.service
Wants=network-online.target
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
TimeoutStartSec=0
ExecStart=/usr/local/bin/sudhaar-up

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now sudhaar
