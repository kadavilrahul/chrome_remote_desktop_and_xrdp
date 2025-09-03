#!/bin/bash

# Universal Tools Uninstaller
# Removes all tools installed through run.sh menu

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}Universal Tools Uninstaller${NC}"
echo "==========================="
echo -e "${PURPLE}Removing all tools installed through run.sh${NC}"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root privileges.${NC}"
    echo -e "${YELLOW}Please run with: sudo ./uninstall_tools.sh${NC}"
    exit 1
fi

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

# Function to safely remove a package
safe_remove() {
    local package="$1"
    local description="$2"

    if is_installed "$package"; then
        echo -e "${YELLOW}Removing $description...${NC}"
        apt-get remove --purge -y "$package"
        echo -e "${GREEN}✓ $description removed${NC}"
    else
        echo -e "${BLUE}$description not installed - skipping${NC}"
    fi
}

# Confirm before proceeding
echo -e "${RED}WARNING: This will remove ALL tools installed through run.sh:${NC}"
echo "  - Chrome Remote Desktop"
echo "  - Google Chrome"
echo "  - Visual Studio Code"
echo "  - xRDP"
echo "  - XFCE Desktop"
echo "  - Firefox"
echo "  - LightDM"
echo "  - Go binaries"
echo
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstallation cancelled.${NC}"
    exit 0
fi

echo
echo -e "${BLUE}Starting comprehensive uninstallation...${NC}"
echo

# Stop services before removing
echo -e "${YELLOW}Stopping services...${NC}"
systemctl stop chrome-remote-desktop 2>/dev/null || true
systemctl stop xrdp 2>/dev/null || true
systemctl stop lightdm 2>/dev/null || true
echo -e "${GREEN}✓ Services stopped${NC}"
echo

# Remove Chrome Remote Desktop
safe_remove "chrome-remote-desktop" "Chrome Remote Desktop"

# Remove Google Chrome
safe_remove "google-chrome-stable" "Google Chrome"

# Remove Visual Studio Code
safe_remove "code" "Visual Studio Code"

# Remove xRDP
safe_remove "xrdp" "xRDP"

# Remove XFCE Desktop
if is_installed "xfce4"; then
    echo -e "${YELLOW}Removing XFCE Desktop...${NC}"
    apt-get remove --purge -y xfce4 xfce4-goodies
    echo -e "${GREEN}✓ XFCE Desktop removed${NC}"
else
    echo -e "${BLUE}XFCE Desktop not installed - skipping${NC}"
fi

# Remove Firefox
safe_remove "firefox" "Firefox"

# Remove LightDM
safe_remove "lightdm" "LightDM"

# Clean up orphaned packages
echo -e "${YELLOW}Removing orphaned packages...${NC}"
apt-get autoremove -y
echo -e "${GREEN}✓ Orphaned packages removed${NC}"

# Clean up package cache
echo -e "${YELLOW}Cleaning package cache...${NC}"
apt-get autoclean
echo -e "${GREEN}✓ Package cache cleaned${NC}"

# Remove Go binaries
if [ -d "go" ]; then
    echo -e "${YELLOW}Removing Go binaries...${NC}"
    rm -f go/chrome-remote-desktop
    rm -f go/install-chrome
    rm -f go/install-vscode
    rm -f go/setup-xrdp
    echo -e "${GREEN}✓ Go binaries removed${NC}"
else
    echo -e "${BLUE}Go directory not found - skipping${NC}"
fi

# Clean up configuration files
echo -e "${YELLOW}Cleaning up configuration files...${NC}"

# Remove Chrome Remote Desktop session file
rm -f "/etc/chrome-remote-desktop-session"

# Remove xRDP config files
rm -rf "/etc/xrdp" 2>/dev/null || true

# Remove LightDM config
rm -f "/etc/lightdm/lightdm.conf" 2>/dev/null || true

# Remove XFCE config files
rm -rf "/etc/xdg/xfce4" 2>/dev/null || true

echo -e "${GREEN}✓ Configuration files cleaned${NC}"

# Final system cleanup
echo -e "${YELLOW}Final system cleanup...${NC}"
apt-get autoremove -y >/dev/null 2>&1 || true
apt-get autoclean >/dev/null 2>&1 || true
echo -e "${GREEN}✓ System cleanup completed${NC}"

echo
echo -e "${GREEN}🎉 All tools uninstalled successfully!${NC}"
echo
echo -e "${BLUE}Removed components:${NC}"
echo "  ✓ Chrome Remote Desktop"
echo "  ✓ Google Chrome"
echo "  ✓ Visual Studio Code"
echo "  ✓ xRDP"
echo "  ✓ XFCE Desktop"
echo "  ✓ Firefox"
echo "  ✓ LightDM"
echo "  ✓ Go binaries"
echo "  ✓ Configuration files"
echo "  ✓ Package cache"
echo
echo -e "${YELLOW}Note: System restart recommended for complete cleanup.${NC}"