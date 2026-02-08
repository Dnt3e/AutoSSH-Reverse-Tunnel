#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}Please run as root.${NC}"
  exit 1
fi

echo -e "${GREEN}==========================================${NC}"
echo -e "${YELLOW}      AutoSSH Reverse Tunnel Setup        ${NC}"
echo -e "${GREEN}==========================================${NC}"

# Install Dependencies
echo -e "${YELLOW}[+] Installing dependencies (autossh, sshpass)...${NC}"
if [ -f /etc/debian_version ]; then
    apt-get update -q && apt-get install -y autossh sshpass -q
elif [ -f /etc/redhat-release ]; then
    yum install -y autossh sshpass
else
    echo -e "${RED}OS not supported automatically. Install autossh manually.${NC}"
    exit 1
fi

# User Inputs
echo -e "${GREEN}--- Configuration ---${NC}"
read -p "Enter Remote Server IP (Iran): " REMOTE_IP
read -p "Enter Remote SSH Port (Default 22): " REMOTE_SSH_PORT
REMOTE_SSH_PORT=${REMOTE_SSH_PORT:-22}
read -p "Enter Tunnel Port (e.g., 2001): " TUNNEL_PORT
read -s -p "Enter Remote Server Root Password: " REMOTE_PASS
echo ""

# SSH Key Generation
echo -e "${YELLOW}[+] Generating SSH Keys if missing...${NC}"
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -q
fi

# Transfer SSH Key
echo -e "${YELLOW}[+] Transferring SSH Key to Remote Server...${NC}"
export SSHPASS=$REMOTE_PASS
sshpass -e ssh-copy-id -p $REMOTE_SSH_PORT -o StrictHostKeyChecking=no root@$REMOTE_IP

if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] Failed to copy SSH key. Check IP/Password.${NC}"
    exit 1
fi

# Configure GatewayPorts on Remote
echo -e "${YELLOW}[+] Configuring GatewayPorts on Remote Server...${NC}"
sshpass -e ssh -p $REMOTE_SSH_PORT -o StrictHostKeyChecking=no root@$REMOTE_IP \
"sed -i 's/#GatewayPorts no/GatewayPorts yes/g' /etc/ssh/sshd_config; \
 sed -i 's/#GatewayPorts yes/GatewayPorts yes/g' /etc/ssh/sshd_config; \
 grep -qxF 'GatewayPorts yes' /etc/ssh/sshd_config || echo 'GatewayPorts yes' >> /etc/ssh/sshd_config; \
 service ssh restart || service sshd restart"

# Create Systemd Service
echo -e "${YELLOW}[+] Creating Systemd Service...${NC}"
SERVICE_NAME="autotunnel-${TUNNEL_PORT}"
cat <<EOF > /etc/systemd/system/${SERVICE_NAME}.service
[Unit]
Description=AutoSSH Tunnel Port ${TUNNEL_PORT}
After=network.target

[Service]
Environment="AUTOSSH_GATETIME=0"
ExecStart=/usr/bin/autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "ExitOnForwardFailure yes" -o "StrictHostKeyChecking=no" -N -R 0.0.0.0:${TUNNEL_PORT}:127.0.0.1:${TUNNEL_PORT} -p ${REMOTE_SSH_PORT} root@${REMOTE_IP}
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOF

# Start Service
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}
systemctl restart ${SERVICE_NAME}

echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}       Tunnel Established!                ${NC}"
echo -e "${GREEN}==========================================${NC}"

# Show Status
systemctl status ${SERVICE_NAME} --no-pager
