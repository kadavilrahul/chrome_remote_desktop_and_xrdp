#!/bin/bash

# Update system and install necessary packages
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install XFCE and xRDP if not already installed
echo "Installing XFCE and xRDP..."
sudo apt install -y xfce4 xfce4-goodies xrdp

# Set XFCE as the default session for xRDP
echo "Setting XFCE as default session for xRDP..."
echo "xfce4-session" > ~/.xsession

# Enable and start xRDP service
echo "Starting and enabling xRDP service..."
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Configure xRDP settings for better performance
echo "Configuring xRDP settings..."

# Edit xrdp.ini for better performance
sudo sed -i 's/bitmap_cache=true/bitmap_cache=false/' /etc/xrdp/xrdp.ini
sudo sed -i 's/bitmap_cache_size=32768/bitmap_cache_size=16384/' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/max_bpp=16/' /etc/xrdp/xrdp.ini
sudo sed -i 's/encryption_level=high/encryption_level=low/' /etc/xrdp/xrdp.ini

# Restart xRDP service to apply changes
echo "Restarting xRDP service..."
sudo systemctl restart xrdp

# Disable unnecessary startup applications for XFCE
echo "Disabling unnecessary XFCE startup applications..."
mkdir -p ~/.config/autostart
echo "[Desktop Entry]
Name=Update
Exec=sh -c 'sleep 5 && gnome-software'
Type=Application
Hidden=true" > ~/.config/autostart/gnome-software.desktop

# Disable desktop effects in XFCE (optional for more performance)
echo "Disabling desktop effects..."
gsettings set org.xfce.compiz.general compositing false

# Configure network performance optimizations (optional)
echo "Optimizing network settings..."
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
sudo sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216'
sudo sysctl -w net.ipv4.tcp_wmem='4096 16384 16777216'
sudo sysctl -w net.ipv4.tcp_mtu_probing=1

# Install Firefox
echo "Installing Firefox..."
sudo apt-get install -y firefox

# Install Chromium
echo "Installing Chromium..."
sudo apt-get install -y chromium-browser

# Create Chromium desktop shortcut for root
echo "Creating Chromium desktop shortcut..."
cat << EOF | sudo tee /usr/share/applications/chromium-root.desktop
[Desktop Entry]
Version=1.0
Name=Chromium (Root)
Comment=Access the Internet
Exec=chromium --no-sandbox --user-data-dir=/root/.chromium-data
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=chromium-browser
Categories=Network;WebBrowser;
StartupNotify=true
EOF

# Install VS Code using Microsoft repository
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
rm packages.microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update
sudo apt-get install -y code

# Create VS Code desktop shortcut for root
echo "Creating VS Code desktop shortcut..."
cat << EOF | sudo tee /usr/share/applications/code-root.desktop
[Desktop Entry]
Name=Visual Studio Code (Root)
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=sudo code --no-sandbox --user-data-dir=/root/.vscode
Icon=vscode
Type=Application
Terminal=false
Categories=Development;TextEditor;
StartupNotify=true
EOF

# Install Windsurf
echo "Installing Windsurf..."
curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
sudo apt-get update
sudo apt-get upgrade windsurf -y

# Create Windsurf desktop shortcut for root
echo "Creating Windsurf desktop shortcut..."
cat << EOF | sudo tee /usr/share/applications/windsurf-root.desktop
[Desktop Entry]
Name=Windsurf (Root)
Comment=Agentic IDE by Codeium
GenericName=Text Editor
Exec=windsurf --no-sandbox --user-data-dir=/root/.windsurf-data
Icon=windsurf
Type=Application
Terminal=false
Categories=Development;TextEditor;
StartupNotify=true
EOF

# Allow root X server access
echo "Configuring X server access..."
echo "xhost +SI:localuser:root" >> ~/.profile
echo "xhost +SI:localuser:\$(whoami)" >> ~/.profile

# Make desktop entries executable
sudo chmod +x /usr/share/applications/chromium-root.desktop
sudo chmod +x /usr/share/applications/code-root.desktop
sudo chmod +x /usr/share/applications/windsurf-root.desktop

# Restart the system for all changes to take effect
echo "System will now restart to apply all optimizations."
sudo reboot
