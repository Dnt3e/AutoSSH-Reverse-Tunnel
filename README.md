# AutoSSH Reverse Tunnel 🚇

![GitHub](https://img.shields.io/badge/Developed%20by-Dnt3e-blue)
![Shell Script](https://img.shields.io/badge/Language-Bash-green)
![License](https://img.shields.io/badge/License-MIT-orange)

An intelligent, automated Bash script to set up a **Reverse SSH Tunnel** between two servers.
This tool is specifically designed for scenarios where inbound traffic is blocked (e.g., behind NAT or strict firewalls), allowing you to initiate the connection from an external server to the restricted server securely and persistently.

> **Created with ❤️ by [Dnt3e](https://github.com/Dnt3e)**

## ✨ Features

- 🚀 **One-Line Setup:** Installs and configures everything automatically.
- 🔄 **Persistent Connection:** Uses `Autossh` to monitor the tunnel and restart it if it drops.
- 🛡️ **Systemd Service:** automatically starts the tunnel on boot or after a crash.
- 🔑 **Auto Configuration:** Handles SSH Key exchange and `GatewayPorts` configuration on the remote server automatically.
- 🎯 **No Client Config:** No software installation required on the destination (remote) server.

  ## ⚙️ How to Use

After running the installation command, the script will prompt you for the following details:

1. **Remote IP:** The IP address of the destination server (e.g., the server inside Iran/Restricted Network).
2. **Remote SSH Port:** The SSH port of the remote server (Default: `22`).
3. **Tunnel Port:** The specific port you want to forward/tunnel (e.g., `2001`).
4. **Password:** The root password of the remote server (Required only once for setting up SSH keys).

✅ **Done!** The service will start automatically and keep the tunnel alive.

## 🛠 Requirements

- **Source Server (local):** Linux (Ubuntu/Debian/CentOS) with Root access.
- **Destination Server (remote):** Must have SSH service running.
- **Dependencies:** `autossh`, `sshpass` (The script installs these automatically).

## 📥 Installation

Run the following command on your **Source Server** (e.g., the server outside the restricted network):

```bash
wget https://raw.githubusercontent.com/Dnt3e/AutoSSH-Reverse-Tunnel/main/Tunnel.sh
chmod +x Tunnel.sh
./Tunnel.sh
