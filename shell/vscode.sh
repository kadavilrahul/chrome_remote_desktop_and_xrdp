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

echo -e "${BLUE}Installing Visual Studio Code${NC}"
echo -e "${YELLOW}Detected distribution: $DISTRIBUTION${NC}"
echo -e "${YELLOW}Detected package manager: $PACKAGE_MANAGER${NC}"
echo

# Install VS Code based on package manager
case $PACKAGE_MANAGER in
    "apt")
        echo -e "${GREEN}Installing VS Code for Debian/Ubuntu based system...${NC}"

        # Install prerequisites
        apt update
        apt install -y wget apt-transport-https

        # Add Microsoft GPG key and repository
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
        rm packages.microsoft.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list

        # Update and install
        apt update
        apt install -y code

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}VS Code installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install VS Code${NC}"
            exit 1
        fi
        ;;

    "dnf")
        echo -e "${GREEN}Installing VS Code for Red Hat/Fedora based system...${NC}"

        # Import Microsoft GPG key
        rpm --import https://packages.microsoft.com/keys/microsoft.asc

        # Add VS Code repository
        cat << EOF | tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

        # Install VS Code
        dnf install -y code

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}VS Code installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install VS Code${NC}"
            exit 1
        fi
        ;;

    "pacman")
        echo -e "${GREEN}Installing VS Code for Arch Linux based system...${NC}"

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

        echo "Installing VS Code from AUR..."
        yay -S visual-studio-code-bin --noconfirm

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}VS Code installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install VS Code${NC}"
            exit 1
        fi
        ;;

    "zypper")
        echo -e "${GREEN}Installing VS Code for openSUSE based system...${NC}"

        # Import Microsoft GPG key
        rpm --import https://packages.microsoft.com/keys/microsoft.asc

        # Add VS Code repository
        cat << EOF | tee /etc/zypp/repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

        # Install VS Code
        zypper refresh
        zypper install -y code

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}VS Code installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install VS Code${NC}"
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
echo -e "${GREEN}VS Code installation completed!${NC}"
echo -e "${BLUE}You can now launch VS Code from your applications menu or by running 'code' in terminal${NC}"