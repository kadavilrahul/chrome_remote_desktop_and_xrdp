#!/bin/bash

echo "Building Go tools..."

go build -o chrome-remote-desktop chrome-remote-desktop.go
go build -o install-chrome install-chrome.go
go build -o install-vscode install-vscode.go
go build -o setup-xrdp setup-xrdp.go

echo "All Go tools built successfully!"
echo ""
echo "Available tools:"
echo "  ./chrome-remote-desktop    - Auto-detect and install Chrome Remote Desktop"
echo "  ./install-chrome           - Install Google Chrome Browser"
echo "  ./install-vscode           - Install Visual Studio Code"
echo "  ./setup-xrdp               - Setup xRDP for Microsoft RDP access"