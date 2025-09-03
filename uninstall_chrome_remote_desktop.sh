#!/bin/bash

# Chrome Remote Desktop Uninstaller
# This script will completely remove Chrome Remote Desktop and the created user

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Chrome Remote Desktop Uninstaller${NC}"
echo "=================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root privileges.${NC}"
    echo -e "${YELLOW}Please run with: sudo ./uninstall.sh${NC}"
    exit 1
fi

# Read config to get username
CONFIG_FILE="/root/chrome_remote_desktop_and_xrdp/config.json"
if [ -f "$CONFIG_FILE" ]; then
    USERNAME=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['user']['username'])" 2>/dev/null || echo "")
    if [ -z "$USERNAME" ]; then
        echo -e "${YELLOW}Could not read username from config file.${NC}"
        read -p "Enter the username that was created during installation: " USERNAME
    fi
else
    echo -e "${YELLOW}Config file not found.${NC}"
    read -p "Enter the username that was created during installation: " USERNAME
fi

echo -e "${BLUE}Username to remove: ${USERNAME}${NC}"

# Confirm before proceeding
echo
echo -e "${RED}WARNING: This will:${NC}"
echo "  - Stop and remove Chrome Remote Desktop"
echo "  - Delete user: $USERNAME"
echo "  - Remove user's home directory"
echo "  - Delete config files"
echo
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstallation cancelled.${NC}"
    exit 0
fi

echo
echo -e "${BLUE}Starting uninstallation...${NC}"

# Step 1: Stop Chrome Remote Desktop service
echo -e "${YELLOW}Step 1: Stopping Chrome Remote Desktop service...${NC}"
if systemctl is-active --quiet chrome-remote-desktop; then
    systemctl stop chrome-remote-desktop
    echo -e "${GREEN}✓ Service stopped${NC}"
else
    echo -e "${BLUE}Service not running${NC}"
fi

# Step 2: Remove Chrome Remote Desktop package
echo -e "${YELLOW}Step 2: Removing Chrome Remote Desktop package...${NC}"
if dpkg -l | grep -q chrome-remote-desktop; then
    apt-get remove --purge -y chrome-remote-desktop
    apt-get autoremove -y
    apt-get autoclean
    echo -e "${GREEN}✓ Package removed${NC}"
else
    echo -e "${BLUE}Package not found${NC}"
fi

# Step 3: Remove the user and their home directory
echo -e "${YELLOW}Step 3: Removing user and home directory...${NC}"
if id "$USERNAME" &>/dev/null; then
    # Kill any processes owned by the user
    pkill -u "$USERNAME" 2>/dev/null || true

    # Remove the user and their home directory
    userdel -r "$USERNAME" 2>/dev/null || true
    echo -e "${GREEN}✓ User $USERNAME and home directory removed${NC}"
else
    echo -e "${BLUE}User $USERNAME not found${NC}"
fi

# Step 4: Remove Chrome Remote Desktop group
echo -e "${YELLOW}Step 4: Removing Chrome Remote Desktop group...${NC}"
if getent group chrome-remote-desktop > /dev/null; then
    groupdel chrome-remote-desktop 2>/dev/null || true
    echo -e "${GREEN}✓ Group removed${NC}"
else
    echo -e "${BLUE}Group not found${NC}"
fi

# Step 5: Clean up configuration files
echo -e "${YELLOW}Step 5: Cleaning up configuration files...${NC}"

# Remove Chrome Remote Desktop session file
if [ -f "/etc/chrome-remote-desktop-session" ]; then
    rm -f "/etc/chrome-remote-desktop-session"
    echo -e "${GREEN}✓ Session file removed${NC}"
fi

# Remove config file
if [ -f "$CONFIG_FILE" ]; then
    rm -f "$CONFIG_FILE"
    echo -e "${GREEN}✓ Config file removed${NC}"
fi

# Remove any remaining Chrome Remote Desktop files
rm -rf "/opt/google/chrome-remote-desktop" 2>/dev/null || true
rm -f "/etc/chromium-browser/default" 2>/dev/null || true

# Clean up any downloaded .deb files
rm -f "/root/chrome_remote_desktop_and_xrdp/chrome-remote-desktop_current_amd64.deb" 2>/dev/null || true
rm -f "/root/chrome_remote_desktop_and_xrdp/chrome-remote-desktop_current_amd64.deb.*" 2>/dev/null || true

echo -e "${GREEN}✓ Cleanup completed${NC}"

# Step 6: Final system cleanup
echo -e "${YELLOW}Step 6: Final system cleanup...${NC}"
apt-get autoremove -y >/dev/null 2>&1 || true
apt-get autoclean >/dev/null 2>&1 || true
echo -e "${GREEN}✓ System cleanup completed${NC}"

echo
echo -e "${GREEN}🎉 Chrome Remote Desktop uninstallation completed successfully!${NC}"
echo
echo -e "${BLUE}Summary of removed items:${NC}"
echo "  - Chrome Remote Desktop package"
echo "  - User: $USERNAME"
echo "  - User's home directory"
echo "  - Chrome Remote Desktop group"
echo "  - Configuration files"
echo "  - Downloaded installation files"
echo
echo -e "${YELLOW}Note: You may need to restart your system for all changes to take effect.${NC}"