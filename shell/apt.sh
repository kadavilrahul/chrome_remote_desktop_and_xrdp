#!/bin/bash

# Chrome Remote Desktop Installation for Debian/Ubuntu
echo "✅ Debian/Ubuntu detected - This is officially supported by Google Chrome Remote Desktop"
echo ""

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Chrome Remote Desktop
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg -i chrome-remote-desktop_current_amd64.deb
sudo apt --fix-broken install -y
sudo apt --fix-missing install -y

# Install XFCE
sudo apt install -y xfce4 xfce4-goodies

# Install Display Manager if not installed
sudo apt install -y lightdm

# Configure Chrome Remote Desktop to use XFCE
echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" | sudo tee /etc/chrome-remote-desktop-session

# Read user details from config.json
if [ -f "config.json" ]; then
    NEW_USER=$(python3 -c "import json; print(json.load(open('config.json'))['user']['username'])")
    USER_PASSWORD=$(python3 -c "import json; print(json.load(open('config.json'))['user']['password'])")
    echo "Using username from config.json: $NEW_USER"
else
    echo "config.json not found. Creating one now..."
    echo "Please enter the following details:"
    
    read -p "Enter username: " NEW_USER
    read -s -p "Enter password: " USER_PASSWORD
    echo
    
    # Create config.json with user inputs
    cat > config.json << EOF
{
  "user": {
    "username": "$NEW_USER",
    "password": "$USER_PASSWORD"
  }
}
EOF
    
    echo "config.json created successfully!"
fi

# Add the user and set the password
sudo adduser --disabled-password --gecos "" $NEW_USER
echo "$NEW_USER:$USER_PASSWORD" | sudo chpasswd

# Add the user to the sudo group
sudo usermod -aG sudo $NEW_USER

# Create the chrome-remote-desktop group and add the user
sudo groupadd chrome-remote-desktop
sudo usermod -aG chrome-remote-desktop $NEW_USER

# Install Firefox
sudo apt install -y firefox

echo "Installation complete."

# Instructions for the user
echo "You are now being logged in as $NEW_USER."
echo "Install Chrome remote desktop extension on your browser"
echo "Open and go to Setup via"
echo "SSH > Set up another computer > begin > next > authorize > Debian Linux > Copy command"
echo "Paste the command copied from chrome remote desktop here and enter"
echo "Enter pin"
echo "The remote dektop connection should now be running"

# Switch to the new user
echo "Switching to user $NEW_USER..."
exec su - $NEW_USER
