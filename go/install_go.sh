#!/bin/bash

# Go Installation Script
# Installs Go programming language and toolchain

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Go Installation Script${NC}"
echo "======================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root privileges.${NC}"
    echo -e "${YELLOW}Please run with: sudo ./install_go.sh${NC}"
    exit 1
fi

# Check if Go is already installed
if command -v go &> /dev/null; then
    INSTALLED_VERSION=$(go version | awk '{print $3}')
    echo -e "${GREEN}Go is already installed: ${INSTALLED_VERSION}${NC}"
    echo -e "${YELLOW}Do you want to reinstall/upgrade Go?${NC}"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installation cancelled.${NC}"
        exit 0
    fi
fi

echo -e "${BLUE}Installing Go programming language...${NC}"

# Fix any interrupted dpkg configurations first
echo -e "${YELLOW}Checking for interrupted package configurations...${NC}"
if dpkg --configure -a >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Fixed any interrupted package configurations${NC}"
fi

# Update package list
echo -e "${YELLOW}Updating package list...${NC}"
if ! apt update; then
    echo -e "${RED}⚠️  Warning: apt update failed, but continuing with installation...${NC}"
fi

# Install Go
echo -e "${YELLOW}Installing Go...${NC}"
if apt install -y golang-go; then
    echo -e "${GREEN}✓ Go installed successfully${NC}"

    # Verify installation
    if command -v go &> /dev/null; then
        VERSION=$(go version)
        echo -e "${GREEN}✓ Go version: ${VERSION}${NC}"

        # Set up Go environment (optional)
        echo -e "${YELLOW}Setting up Go environment...${NC}"

        # Create Go workspace directory if it doesn't exist
        if [ ! -d "/home/$(logname)/go" ]; then
            mkdir -p "/home/$(logname)/go"
            chown "$(logname):$(logname)" "/home/$(logname)/go"
            echo -e "${GREEN}✓ Created Go workspace: /home/$(logname)/go${NC}"
        fi

        echo
        echo -e "${GREEN}🎉 Go installation completed successfully!${NC}"
        echo
        echo -e "${BLUE}Go is now ready to use:${NC}"
        echo "  • Run 'go version' to verify installation"
        echo "  • Run 'go help' for available commands"
        echo "  • Go workspace: ~/go"
        echo
        echo -e "${YELLOW}You can now build Go tools using option 9 in the main menu.${NC}"

    else
        echo -e "${RED}✗ Go installation verification failed${NC}"
        exit 1
    fi

else
    echo -e "${RED}✗ Failed to install Go${NC}"
    echo -e "${YELLOW}You can try installing Go manually:${NC}"
    echo "  sudo apt update"
    echo "  sudo apt install golang-go"
    exit 1
fi