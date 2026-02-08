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

## 📥 Installation

Run the following command on your **Source Server** (e.g., the server outside the restricted network):

```bash
wget https://raw.githubusercontent.com/Dnt3e/AutoSSH-Reverse-Tunnel/main/tunnel.sh
chmod +x tunnel.sh
./tunnel.sh
