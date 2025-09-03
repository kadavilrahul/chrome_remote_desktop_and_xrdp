# Server Setup Tools

This repository contains automated installers for server setup and Chrome Remote Desktop that work across different Linux distributions. Available in both shell script and Go versions.

## 🚀 Quick Start

### Interactive Version Selection (Recommended)
```bash
sudo ./run.sh
```

### Direct Commands
```bash
# Run Go version directly
sudo ./run.sh go

# Run Shell version directly
sudo ./run.sh shell

# Build Go binary
./run.sh build

# Show help
./run.sh --help
```

### Manual Execution
```bash
# Go version
cd go/ && make build
sudo ./build/chrome-remote-desktop-installer

# Shell version
sudo bash shell/run.sh
```

## Supported Distributions

- Debian/Ubuntu based systems (using apt) - Tested Ok ✅
- Red Hat/Fedora based systems (using dnf) - Not tested ❌
- Arch Linux based systems (using pacman) - Not tested ❌
- openSUSE based systems (using zypper) - Not tested ❌

## Tested on

- Ubuntu 24.04

## Usage

## 📋 Version Selection Menu

The main `run.sh` presents three options:

1. **Go Version (Recommended)** - Modern, fast, and feature-rich
   - Single binary with no dependencies
   - Better error handling and UX  
   - Comprehensive development tools

2. **Shell Script Version (Legacy)** - Original Chrome Remote Desktop installer
   - Simple and lightweight
   - Compatible with minimal systems

3. **Direct Commands** - Run specific functionality directly

## 🛠️ Available Features

### Go Version Features
- Development tools (GitHub CLI, OpenCode, Gemini CLI, CLOC, Node.js, Zoxide, Google Cloud CLI)
- System configuration (timezone, aliases)
- Repository management (clone favorites, browse repos)
- SSH connection helpers

### Shell Version Features  
- Chrome Remote Desktop installation
- Google Chrome and VS Code installation
- xRDP setup
- Multi-distro package manager support

### Alternative: Direct Script Execution

You can also run individual scripts directly:

1. **Auto-detection script**:
   ```bash
   sudo ./chrome_remote_desktop.sh
   ```

2. **Package manager specific scripts**:
   ```bash
   sudo ./apt.sh        # For Debian/Ubuntu
   sudo ./dnf.sh        # For Red Hat/Fedora  
   sudo ./pacman.sh     # For Arch Linux
   sudo ./zypper.sh     # For openSUSE
   ```

3. **Other scripts**:
   ```bash
   sudo ./chrome.sh                 # Install Google Chrome Browser
   sudo ./vscode.sh                 # Install Visual Studio Code
   sudo ./xrdp/setup_rdp.sh         # Setup xRDP
   ```
### Setup Process

1. Follow the interactive prompts:
   - Enter a username when prompted
   - Enter and confirm your password
   - Wait for the installation to complete

2. On your Ubuntu server:
   - You will be automatically loggged in with your newly created user credentials
   - You may also do it manually if needed by using the command `su $NEW_USER`  
    
3. Install the Chrome Remote Desktop extension in your Chrome browser

4. Navigate to Chrome Remote Desktop settings:
   - Go to "Setup via SSH"
   - Select "Set up another computer"
   - Click "Begin" > "Next" > "Authorize"
   - Choose "Debian Linux"
   - Copy the provided command

5. On your Ubuntu server:
   - Paste and run the command copied from Chrome Remote Desktop
   - Set up a PIN when prompted
   - Complete the on-screen setup process

6. Install additional software (Optional)
   - Use the menu options in `run.sh` for Google Chrome (option 2) or VS Code (option 3), or run directly:
   ```bash
   sudo ./chrome.sh     # Install Google Chrome Browser
   sudo ./vscode.sh     # Install Visual Studio Code
   ```
   
## What gets installed

- Chrome Remote Desktop
- XFCE Desktop Environment
- LightDM Display Manager
- Firefox Web Browser
- Required dependencies

## Features

- **Interactive Menu Interface**: Easy-to-use boxed menu with all installation options
- **Auto-detection**: Automatically detects your Linux distribution and package manager
- **Multiple Installation Options**: Support for different package managers and specific tools
- **XFCE Desktop Environment**: Sets up Chrome Remote Desktop with XFCE
- **Additional Tools**: Includes VS Code installation and xRDP setup options

## Benefits

- Access your server's GUI from any device
- Fast and secure remote access
- Run graphical applications seamlessly
- Better alternative to traditional SSH for GUI needs
- High-speed connection for smooth operation

## Troubleshooting

If you encounter any issues:
1. Try installing Chrome reote desktop as a new user
2. Reinstall the OS if a residual version of Chrome Remote Desktop create issues
3. Do not reboot or sudo reboot from Chrome remote desktop
4. Remember Chrome remote desktop works with non root user only
5. If you want to install remote desktop on root use then use RDP.

## 📁 Project Structure

```
chrome_remote_desktop_and_xrdp/
├── run.sh                      # Main launcher with version selection
├── go/                         # Go implementation (recommended)
│   ├── chrome-remote-desktop-installer  # Binary executable
│   ├── cmd/                    # CLI commands
│   ├── internal/               # Application logic
│   └── pkg/                    # Shared packages
├── shell/                      # Shell script implementation (legacy)  
│   ├── run.sh                  # Shell version menu
│   ├── chrome_remote_desktop.sh # Auto-detection script
│   ├── apt.sh, dnf.sh, etc.    # Package manager scripts
│   ├── chrome.sh, vscode.sh    # Additional tools
│   └── sample_config.json      # Configuration example
└── xrdp/
    └── setup_rdp.sh            # xRDP setup
```

### Examples Folder

The `examples/` folder contains:
- **`examples/install_chrome_remote_desktop_version-01.sh`**: Alternative installer with user creation

## Alternate recommended remote desktop applications

1. **XRDP with Microsoft RDP**
   - Use menu option 4 in `run.sh`, or run:
   ```bash
   cd xrdp && sudo ./setup_rdp.sh
   ```
   - Follow the xrdp/README.md for additional details

2. Helpwire - https://www.helpwire.app/

## Security Note

- Always use strong passwords
- Keep your PIN secure
- Regularly update your system
- Monitor remote access sessions

## Contributing

Feel free to submit issues and enhancement requests!
If you happen to run, modify scripts for other distros, please submit pr and mr.
