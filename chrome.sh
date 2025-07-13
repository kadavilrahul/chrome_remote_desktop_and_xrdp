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

echo -e "${BLUE}Installing Google Chrome Browser${NC}"
echo -e "${YELLOW}Detected distribution: $DISTRIBUTION${NC}"
echo -e "${YELLOW}Detected package manager: $PACKAGE_MANAGER${NC}"
echo

# Install Google Chrome based on package manager
case $PACKAGE_MANAGER in
    "apt")
        echo -e "${GREEN}Installing Google Chrome for Debian/Ubuntu based system...${NC}"
        
        # Download the .deb package from Google
        echo "Downloading Google Chrome..."
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Download completed successfully${NC}"
            
            # Install the downloaded package
            echo "Installing Google Chrome..."
            apt install -y ./google-chrome-stable_current_amd64.deb
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Google Chrome installed successfully!${NC}"
                
                # Clean up downloaded file
                rm -f google-chrome-stable_current_amd64.deb
                echo "Cleaned up download files"
            else
                echo -e "${RED}Failed to install Google Chrome${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Failed to download Google Chrome${NC}"
            exit 1
        fi
        ;;
        
    "dnf")
        echo -e "${GREEN}Installing Google Chrome for Red Hat/Fedora based system...${NC}"
        
        # Download the .rpm package from Google
        echo "Downloading Google Chrome..."
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Download completed successfully${NC}"
            
            # Install the downloaded package
            echo "Installing Google Chrome..."
            dnf install -y ./google-chrome-stable_current_x86_64.rpm
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Google Chrome installed successfully!${NC}"
                
                # Clean up downloaded file
                rm -f google-chrome-stable_current_x86_64.rpm
                echo "Cleaned up download files"
            else
                echo -e "${RED}Failed to install Google Chrome${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Failed to download Google Chrome${NC}"
            exit 1
        fi
        ;;
        
    "pacman")
        echo -e "${GREEN}Installing Google Chrome for Arch Linux based system...${NC}"
        
        # Check if yay is installed for AUR access
        if ! command -v yay &> /dev/null; then
            echo "Installing yay AUR helper..."
            pacman -S --noconfirm git base-devel
            
            # Create temporary user for building yay (makepkg can't run as root)
            useradd -m temp_builder
            echo "temp_builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
            
            su - temp_builder -c "
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
            "
            
            # Clean up
            userdel -r temp_builder
            sed -i '/temp_builder ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
        fi
        
        echo "Installing Google Chrome from AUR..."
        su - $(logname) -c "yay -S google-chrome --noconfirm"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Google Chrome installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install Google Chrome${NC}"
            exit 1
        fi
        ;;
        
    "zypper")
        echo -e "${GREEN}Installing Google Chrome for openSUSE based system...${NC}"
        
        # Download the .rpm package from Google
        echo "Downloading Google Chrome..."
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Download completed successfully${NC}"
            
            # Install the downloaded package
            echo "Installing Google Chrome..."
            zypper install -y --allow-unsigned-rpm ./google-chrome-stable_current_x86_64.rpm
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Google Chrome installed successfully!${NC}"
                
                # Clean up downloaded file
                rm -f google-chrome-stable_current_x86_64.rpm
                echo "Cleaned up download files"
            else
                echo -e "${RED}Failed to install Google Chrome${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Failed to download Google Chrome${NC}"
            exit 1
        fi
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

echo
echo -e "${GREEN}Google Chrome installation completed!${NC}"
echo -e "${BLUE}You can now launch Google Chrome from your applications menu or by running 'google-chrome' in terminal${NC}"