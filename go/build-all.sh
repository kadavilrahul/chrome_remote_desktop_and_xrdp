#!/bin/bash

echo "Building Go tools..."

# Check if Go is installed, install if missing
if ! command -v go &> /dev/null; then
    echo "Go is not installed. Installing Go..."

    # Fix any interrupted dpkg configurations first
    if dpkg --configure -a >/dev/null 2>&1; then
        echo "Fixed any interrupted package configurations"
    fi

    # Update package list
    if ! apt update; then
        echo "⚠️  Warning: apt update failed, but continuing with installation..."
    fi

    # Install Go
    if apt install -y golang-go; then
        echo "✅ Go installed successfully"
    else
        echo "❌ Failed to install Go"
        echo "Please install Go manually: sudo apt install golang-go"
        echo "Or run: sudo dpkg --configure -a && sudo apt install golang-go"
        exit 1
    fi
fi

# Initialize Go module if needed
if [ ! -f "go.mod" ]; then
    echo "Initializing Go module..."
    go mod init chrome-remote-desktop-tools
    go get golang.org/x/term
fi

# Ensure dependencies are available
echo "Ensuring dependencies..."
go mod tidy

# Build tools with error checking
FAILED=""

if ! go build -o chrome-remote-desktop chrome-remote-desktop.go; then
    echo "❌ Failed to build chrome-remote-desktop"
    FAILED="$FAILED chrome-remote-desktop"
else
    echo "✅ Built chrome-remote-desktop"
fi

if ! go build -o install-chrome install-chrome.go; then
    echo "❌ Failed to build install-chrome"
    FAILED="$FAILED install-chrome"
else
    echo "✅ Built install-chrome"
fi

if ! go build -o install-vscode install-vscode.go; then
    echo "❌ Failed to build install-vscode"
    FAILED="$FAILED install-vscode"
else
    echo "✅ Built install-vscode"
fi

if ! go build -o setup-xrdp setup-xrdp.go; then
    echo "❌ Failed to build setup-xrdp"
    FAILED="$FAILED setup-xrdp"
else
    echo "✅ Built setup-xrdp"
fi

echo ""

if [ -n "$FAILED" ]; then
    echo "❌ Some tools failed to build:$FAILED"
    echo "Please check the error messages above."
    exit 1
else
    echo "✅ All Go tools built successfully!"
    echo ""
    echo "Available tools:"
    echo "  ./chrome-remote-desktop    - Auto-detect and install Chrome Remote Desktop"
    echo "  ./install-chrome           - Install Google Chrome Browser"
    echo "  ./install-vscode           - Install Visual Studio Code"
    echo "  ./setup-xrdp               - Setup xRDP for Microsoft RDP access"
fi