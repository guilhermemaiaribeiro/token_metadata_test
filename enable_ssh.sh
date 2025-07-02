#!/bin/bash

# Simple SSH Server Setup Script

# Install SSH server
sudo apt update
sudo apt install -y openssh-server

# Enable password authentication
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Disable root login
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Start SSH service
sudo systemctl enable ssh
sudo systemctl start ssh

# Allow SSH through firewall
sudo ufw allow ssh 2>/dev/null || true

# Create a user (optional)
echo "Create a new user for SSH? (y/n)"
read -r answer
if [[ "$answer" == "y" ]]; then
    echo "Enter username:"
    read -r username
    echo "Enter password for $username:"
    read -s password
    sudo adduser --disabled-password --gecos "" "$username"
    echo "$username:$password" | sudo chpasswd
    echo "User $username created with password"
fi

# Show connection info
echo "SSH server is ready!"
echo "Connect with: ssh username@$(hostname -I | awk '{print $1}')"
