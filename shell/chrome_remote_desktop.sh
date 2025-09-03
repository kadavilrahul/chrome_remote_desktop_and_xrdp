#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

echo "Detected distribution: $DISTRIBUTION"
echo "Detected package manager: $PACKAGE_MANAGER"

# Check if the package manager is supported
case $PACKAGE_MANAGER in
    "apt")
        echo "Installing for Debian/Ubuntu based system..."
        bash "$SCRIPT_DIR/apt.sh"
        ;;
    "dnf")
        echo "Installing for Red Hat/Fedora based system..."
        bash "$SCRIPT_DIR/dnf.sh"
        ;;
    "pacman")
        echo "Installing for Arch Linux based system..."
        bash "$SCRIPT_DIR/pacman.sh"
        ;;
    "zypper")
        echo "Installing for openSUSE based system..."
        bash "$SCRIPT_DIR/zypper.sh"
        ;;
    *)
        echo "Error: Unsupported package manager or Linux distribution"
        echo "This script supports the following distributions:"
        echo "- Debian/Ubuntu (apt)"
        echo "- Red Hat/Fedora (dnf)"
        echo "- Arch Linux (pacman)"
        echo "- openSUSE (zypper)"
        exit 1
        ;;
esac