#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update system
echo "Updating system packages..."
apt update
apt upgrade -y

# Install required dependencies
echo "Installing required dependencies..."
apt install -y wget

# Download and install Chrome Remote Desktop
echo "Installing Chrome Remote Desktop..."
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
dpkg -i chrome-remote-desktop_current_amd64.deb
apt --fix-broken install -y
apt --fix-missing install -y
rm chrome-remote-desktop_current_amd64.deb

# Install XFCE Desktop Environment
echo "Installing XFCE desktop environment..."
DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies

# Install display manager
echo "Installing LightDM display manager..."
DEBIAN_FRONTEND=noninteractive apt install -y lightdm

# Install Firefox browser
echo "Installing Firefox..."
apt install -y firefox-esr

# Configure Chrome Remote Desktop to use XFCE
echo "Configuring Chrome Remote Desktop to use XFCE..."
mkdir -p /etc/chrome-remote-desktop-session
echo "exec /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session

# Create new user
echo "Creating new user for remote access..."
read -p "Enter username: " USERNAME
while [[ -z "$USERNAME" ]]; do
    echo "Username cannot be empty"
    read -p "Enter username: " USERNAME
done

read -s -p "Enter password: " PASSWORD
echo
read -s -p "Confirm password: " PASSWORD2
echo

while [[ "$PASSWORD" != "$PASSWORD2" ]]; do
    echo "Passwords do not match!"
    read -s -p "Enter password: " PASSWORD
    echo
    read -s -p "Confirm password: " PASSWORD2
    echo
done

# Create user and set password
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Add user to necessary groups
usermod -aG sudo "$USERNAME"
usermod -aG chrome-remote-desktop "$USERNAME"

echo "Installation completed!"
echo "Please follow these steps to complete setup:"
echo "1. Install Chrome Remote Desktop extension in your Chrome browser"
echo "2. Go to https://remotedesktop.google.com/access"
echo "3. Click on 'Set up remote access'"
echo "4. Follow the prompts to set up your computer for remote access"
echo "5. When asked, use your newly created username and password"

# Switch to new user
echo "Switching to new user..."
su - "$USERNAME"