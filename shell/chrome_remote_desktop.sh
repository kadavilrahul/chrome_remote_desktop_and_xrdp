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
    elif command -v aptitude &> /dev/null; then
        echo "aptitude"
    else
        echo "unsupported"
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
        echo "✅ This is officially supported by Google Chrome Remote Desktop"
        bash "$SCRIPT_DIR/apt.sh"
        ;;
    "aptitude")
        echo "Installing for Debian/Ubuntu based system (aptitude)..."
        echo "✅ This is officially supported by Google Chrome Remote Desktop"
        bash "$SCRIPT_DIR/apt.sh"
        ;;
    *)
        echo "❌ Error: Chrome Remote Desktop is only officially supported on Debian/Ubuntu"
        echo ""
        echo "🚨 Google Chrome Remote Desktop only works on Debian-based systems!"
        echo ""
        echo "For your distribution, please use xRDP instead:"
        echo "  sudo ./run.sh (then select: Setup xRDP)"
        echo ""
        echo "xRDP works on ALL Linux distributions and provides Microsoft RDP support."
        exit 1
        ;;
esac