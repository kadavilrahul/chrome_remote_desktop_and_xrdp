#!/bin/bash

# Universal Update Script for Chrome Remote Desktop Tools
# Updates all installed tools, system packages, and Go binaries

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}Universal Update Script${NC}"
echo "======================="
echo -e "${PURPLE}Updating all tools and system packages${NC}"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root privileges.${NC}"
    echo -e "${YELLOW}Please run with: sudo ./update.sh${NC}"
    exit 1
fi

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

# Function to update system packages
update_system() {
    echo -e "${YELLOW}Updating system packages...${NC}"
    apt update
    apt upgrade -y
    apt autoremove -y
    apt autoclean
    echo -e "${GREEN}✓ System packages updated${NC}"
}

# Function to update Google Chrome
update_chrome() {
    if is_installed "google-chrome-stable"; then
        echo -e "${YELLOW}Updating Google Chrome...${NC}"
        apt update
        apt install --only-upgrade google-chrome-stable -y
        echo -e "${GREEN}✓ Google Chrome updated${NC}"
    else
        echo -e "${BLUE}Google Chrome not installed - skipping${NC}"
    fi
}

# Function to update Visual Studio Code
update_vscode() {
    if is_installed "code"; then
        echo -e "${YELLOW}Updating Visual Studio Code...${NC}"
        apt update
        apt install --only-upgrade code -y
        echo -e "${GREEN}✓ Visual Studio Code updated${NC}"
    else
        echo -e "${BLUE}Visual Studio Code not installed - skipping${NC}"
    fi
}

# Function to update Chrome Remote Desktop
update_chrome_remote_desktop() {
    if is_installed "chrome-remote-desktop"; then
        echo -e "${YELLOW}Updating Chrome Remote Desktop...${NC}"
        apt update
        apt install --only-upgrade chrome-remote-desktop -y
        echo -e "${GREEN}✓ Chrome Remote Desktop updated${NC}"
    else
        echo -e "${BLUE}Chrome Remote Desktop not installed - skipping${NC}"
    fi
}

# Function to update xRDP
update_xrdp() {
    if is_installed "xrdp"; then
        echo -e "${YELLOW}Updating xRDP...${NC}"
        apt update
        apt install --only-upgrade xrdp -y
        systemctl restart xrdp
        echo -e "${GREEN}✓ xRDP updated and restarted${NC}"
    else
        echo -e "${BLUE}xRDP not installed - skipping${NC}"
    fi
}

# Function to update XFCE
update_xfce() {
    if is_installed "xfce4"; then
        echo -e "${YELLOW}Updating XFCE Desktop...${NC}"
        apt update
        apt install --only-upgrade xfce4 xfce4-goodies -y
        echo -e "${GREEN}✓ XFCE Desktop updated${NC}"
    else
        echo -e "${BLUE}XFCE Desktop not installed - skipping${NC}"
    fi
}

# Function to update Go binaries
update_go_binaries() {
    if [ -d "go" ] && [ -f "go/build-all.sh" ]; then
        echo -e "${YELLOW}Rebuilding Go binaries...${NC}"
        cd go
        ./build-all.sh
        cd ..
        echo -e "${GREEN}✓ Go binaries rebuilt${NC}"
    else
        echo -e "${BLUE}Go binaries not found - skipping${NC}"
    fi
}

# Function to update Firefox (if installed)
update_firefox() {
    if is_installed "firefox"; then
        echo -e "${YELLOW}Updating Firefox...${NC}"
        apt update
        apt install --only-upgrade firefox -y
        echo -e "${GREEN}✓ Firefox updated${NC}"
    else
        echo -e "${BLUE}Firefox not installed - skipping${NC}"
    fi
}

# Function to update LightDM
update_lightdm() {
    if is_installed "lightdm"; then
        echo -e "${YELLOW}Updating LightDM...${NC}"
        apt update
        apt install --only-upgrade lightdm -y
        echo -e "${GREEN}✓ LightDM updated${NC}"
    else
        echo -e "${BLUE}LightDM not installed - skipping${NC}"
    fi
}

# Main update process
echo -e "${BLUE}Starting comprehensive update...${NC}"
echo

# Update system first
update_system
echo

# Update individual tools
update_chrome
update_vscode
update_chrome_remote_desktop
update_xrdp
update_xfce
update_firefox
update_lightdm
echo

# Update Go binaries
update_go_binaries
echo

# Final cleanup
echo -e "${YELLOW}Final system cleanup...${NC}"
apt autoremove -y >/dev/null 2>&1
apt autoclean >/dev/null 2>&1
echo -e "${GREEN}✓ Cleanup completed${NC}"

echo
echo -e "${GREEN}🎉 All tools and system packages updated successfully!${NC}"
echo
echo -e "${BLUE}Updated components:${NC}"
echo "  ✓ System packages (apt update/upgrade)"
echo "  ✓ Google Chrome (if installed)"
echo "  ✓ Visual Studio Code (if installed)"
echo "  ✓ Chrome Remote Desktop (if installed)"
echo "  ✓ xRDP (if installed)"
echo "  ✓ XFCE Desktop (if installed)"
echo "  ✓ Firefox (if installed)"
echo "  ✓ LightDM (if installed)"
echo "  ✓ Go binaries (rebuilt)"
echo
echo -e "${YELLOW}Note: Some updates may require a system restart to take full effect.${NC}"