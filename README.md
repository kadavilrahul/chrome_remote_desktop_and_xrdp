# Chrome Remote Desktop Installer

This is an automated installer for Chrome Remote Desktop that works across different Linux distributions. The installer provides both a user-friendly menu interface and individual scripts for different package managers.

## Supported Distributions

- Debian/Ubuntu based systems (using apt) - Tested Ok ✅
- Red Hat/Fedora based systems (using dnf) - Not tested ❌
- Arch Linux based systems (using pacman) - Not tested ❌
- openSUSE based systems (using zypper) - Not tested ❌

## Tested on

- Ubuntu 24.04

## Usage

### Quick Start (Recommended)

1. Clone the repository and run the interactive menu:
   ```bash
   git clone https://github.com/kadavilrahul/chrome_remote_desktop.git && cd chrome_remote_desktop_and_xrdp
   ```
   ```bash
   bash run.sh
   ```

2. Use the menu to select your preferred installation option:
   - **Option 1**: Auto-detect and install Chrome Remote Desktop (recommended)
   - **Option 2**: Install Google Chrome Browser
   - **Option 3**: Install Visual Studio Code
   - **Option 4**: Setup xRDP
   - **Option 5**: Exit

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

## Available Scripts

- **`run.sh`**: Interactive menu interface (recommended)
- **`chrome_remote_desktop.sh`**: Auto-detection and installation script (formerly main.sh)
- **`apt.sh`**: Installation for Debian/Ubuntu systems
- **`dnf.sh`**: Installation for Red Hat/Fedora systems  
- **`pacman.sh`**: Installation for Arch Linux systems
- **`zypper.sh`**: Installation for openSUSE systems
- **`chrome.sh`**: Google Chrome Browser installation
- **`vscode.sh`**: Visual Studio Code installation
- **`xrdp/setup_rdp.sh`**: xRDP setup for Microsoft RDP access

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
