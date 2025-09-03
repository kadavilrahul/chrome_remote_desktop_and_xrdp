#!/bin/bash

# Colors for better visual appearance
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Function to detect package manager
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

# Function to detect distribution name
detect_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$NAME"
    else
        echo "Unknown Distribution"
    fi
}

# Get package manager and distribution
PACKAGE_MANAGER=$(detect_package_manager)
DISTRIBUTION=$(detect_distribution)

echo -e "${BLUE}Setting up xRDP with XFCE${NC}"
echo -e "${YELLOW}Detected distribution: $DISTRIBUTION${NC}"
echo -e "${YELLOW}Detected package manager: $PACKAGE_MANAGER${NC}"
echo

# Setup xRDP based on package manager
case $PACKAGE_MANAGER in
    "apt")
        echo -e "${GREEN}Setting up xRDP for Debian/Ubuntu based system...${NC}"

        # Update system
        echo "Updating system..."
        apt update && apt upgrade -y

        # Install XFCE and xRDP
        echo "Installing XFCE and xRDP..."
        apt install -y xfce4 xfce4-goodies xrdp

        # Install Firefox
        echo "Installing Firefox..."
        apt install -y firefox

        # Install VS Code
        echo "Installing Visual Studio Code..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
        rm packages.microsoft.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list
        apt update
        apt install -y code
        ;;

    "dnf")
        echo -e "${GREEN}Setting up xRDP for Red Hat/Fedora based system...${NC}"

        # Update system
        echo "Updating system..."
        dnf update -y

        # Install XFCE and xRDP
        echo "Installing XFCE and xRDP..."
        dnf groupinstall -y "Xfce Desktop"
        dnf install -y xrdp

        # Install Firefox
        echo "Installing Firefox..."
        dnf install -y firefox

        # Install VS Code
        echo "Installing Visual Studio Code..."
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        cat << EOF | tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
        dnf install -y code
        ;;

    "pacman")
        echo -e "${GREEN}Setting up xRDP for Arch Linux based system...${NC}"

        # Update system
        echo "Updating system..."
        pacman -Syu --noconfirm

        # Install XFCE and xRDP
        echo "Installing XFCE and xRDP..."
        pacman -S --noconfirm xfce4 xfce4-goodies xrdp

        # Install Firefox
        echo "Installing Firefox..."
        pacman -S --noconfirm firefox

        # Install VS Code
        echo "Installing Visual Studio Code..."
        if ! command -v yay &> /dev/null; then
            pacman -S --noconfirm git base-devel
            useradd -m temp_builder
            echo "temp_builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
            su - temp_builder -c "
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
            "
            userdel -r temp_builder
            sed -i '/temp_builder ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
        fi
        yay -S visual-studio-code-bin --noconfirm
        ;;

    "zypper")
        echo -e "${GREEN}Setting up xRDP for openSUSE based system...${NC}"

        # Update system
        echo "Updating system..."
        zypper refresh
        zypper update -y

        # Install XFCE and xRDP
        echo "Installing XFCE and xRDP..."
        zypper install -t pattern xfce -y
        zypper install -y xrdp

        # Install Firefox
        echo "Installing Firefox..."
        zypper install -y MozillaFirefox

        # Install VS Code
        echo "Installing Visual Studio Code..."
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        cat << EOF | tee /etc/zypp/repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
        zypper install -y code
        ;;

    *)
        echo -e "${RED}Error: Unsupported package manager or Linux distribution${NC}"
        echo "This script supports the following distributions:"
        echo "- Debian/Ubuntu (apt)"
        echo "- Red Hat/Fedora (dnf)"
        echo "- Arch Linux (pacman)"
        echo "- openSUSE (zypper)"
        exit 1
        ;;
esac

# Common xRDP configuration for all distributions
echo "Configuring xRDP..."

# Set XFCE as the default session for xRDP
echo "Setting XFCE as default session for xRDP..."
echo "xfce4-session" > ~/.xsession

# Enable and start xRDP service
echo "Starting and enabling xRDP service..."
systemctl enable xrdp
systemctl start xrdp

# Configure xRDP settings for better performance
echo "Configuring xRDP settings for better performance..."

# Edit xrdp.ini for better performance
sed -i 's/bitmap_cache=true/bitmap_cache=false/' /etc/xrdp/xrdp.ini
sed -i 's/bitmap_cache_size=32768/bitmap_cache_size=16384/' /etc/xrdp/xrdp.ini
sed -i 's/max_bpp=32/max_bpp=16/' /etc/xrdp/xrdp.ini
sed -i 's/encryption_level=high/encryption_level=low/' /etc/xrdp/xrdp.ini

# Restart xRDP service to apply changes
echo "Restarting xRDP service..."
systemctl restart xrdp

# Disable unnecessary startup applications for XFCE
echo "Disabling unnecessary XFCE startup applications..."
mkdir -p ~/.config/autostart
cat << EOF > ~/.config/autostart/gnome-software.desktop
[Desktop Entry]
Name=Update
Exec=sh -c 'sleep 5 && gnome-software'
Type=Application
Hidden=true
EOF

# Disable desktop effects in XFCE (optional for more performance)
echo "Disabling desktop effects..."
gsettings set org.xfce.compiz.general compositing false 2>/dev/null || true

# Configure network performance optimizations (optional)
echo "Optimizing network settings..."
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216'
sysctl -w net.ipv4.tcp_wmem='4096 16384 16777216'
sysctl -w net.ipv4.tcp_mtu_probing=1

# Create VS Code desktop shortcut for root
echo "Creating VS Code desktop shortcut..."
cat << EOF | tee /usr/share/applications/code-root.desktop
[Desktop Entry]
Name=Visual Studio Code (Root)
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=code --no-sandbox --user-data-dir=/root/.vscode
Icon=vscode
Type=Application
Terminal=false
Categories=Development;TextEditor;
StartupNotify=true
EOF

# Allow root X server access
echo "Configuring X server access..."
echo "xhost +SI:localuser:root" >> ~/.profile
echo "xhost +SI:localuser:$(whoami)" >> ~/.profile

# Make desktop entries executable
chmod +x /usr/share/applications/code-root.desktop

echo
echo -e "${GREEN}xRDP setup completed successfully!${NC}"
echo -e "${BLUE}You can now connect using Microsoft Remote Desktop Client${NC}"
echo -e "${YELLOW}Note: A system restart may be required for all changes to take effect${NC}"
echo -e "${YELLOW}To restart manually, run: sudo reboot${NC}"
