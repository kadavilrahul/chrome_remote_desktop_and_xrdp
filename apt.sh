#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

apt update
apt upgrade -y

apt install wget -y

wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
dpkg -i chrome-remote-desktop_current_amd64.deb
apt --fix-broken install -y
apt --fix-missing install -y

apt install xfce4 xfce4-goodies -y
apt install lightdm -y
apt install firefox -y

groupadd chrome-remote-desktop

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

useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

usermod -aG sudo "$USERNAME"
usermod -aG chrome-remote-desktop "$USERNAME"

echo "Installation completed!"
echo "Please follow these steps to complete setup:"
echo "1. Install Chrome Remote Desktop extension in your Chrome browser"
echo "2. Go to https://remotedesktop.google.com/access"
echo "3. Click on 'Set up remote access'"
echo "4. Follow the prompts to set up your computer for remote access"
echo "5. When asked, use your newly created username and password"

su - "$USERNAME"