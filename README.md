# Chrome Remote Desktop Installer

This is an automated installer for Chrome Remote Desktop that works across different Linux distributions. The script will automatically:
1. Deploy Chrome Remote Desktop with a single command
2. Detect your Linux distribution and package manager
3. Run the appropriate installation script
4. Set up Chrome Remote Desktop with XFCE desktop environment
5. Create a new user for remote access
6. Install firefox browser
7. Provide instructions for final setup

## Supported Distributions

- Debian/Ubuntu based systems (using apt) - Tested Ok ✅
- Red Hat/Fedora based systems (using dnf) - Not tested ❌
- Arch Linux based systems (using pacman) - Not tested ❌
- openSUSE based systems (using zypper) - Not tested ❌

## Tested on

- Ubuntu 24.04

## Usage

1. Install git if not already installed, clone the repository, and run the file
   ```bash
   git clone https://github.com/kadavilrahul/chrome_remote_desktop.git && cd chrome_remote_desktop && bash main.sh
   ```
2. Follow the interactive prompts:
   - Enter a username when prompted
   - Enter and confirm your password
   - Wait for the installation to complete

3. On your Ubuntu server:
   - You will be automatically loggged in with your newly created user credentials
   - You may also do it manually if needed by using the command `su $NEW_USER`  
    
4. Install the Chrome Remote Desktop extension in your Chrome browser

5. Navigate to Chrome Remote Desktop settings:
   - Go to "Setup via SSH"
   - Select "Set up another computer"
   - Click "Begin" > "Next" > "Authorize"
   - Choose "Debian Linux"
   - Copy the provided command

6. On your Ubuntu server:
   - Paste and run the command copied from Chrome Remote Desktop
   - Set up a PIN when prompted
   - Complete the on-screen setup process

7. Install VS Code (Optional)
   - Exit to root
   ```bash
   exit
   ```
   - Run VS Code script
   ```bash
   cd chrome_remote_desktop && bash vscode.sh
   ```
   
## What gets installed

- Chrome Remote Desktop
- XFCE Desktop Environment
- LightDM Display Manager
- Firefox Web Browser
- Required dependencies

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

## Alternate recommended remote desktop applications

1. XRDP with Microsoft RPD
```bas
cd xrdp
```

Follow README.md of that folder.

2. Helpwire - https://www.helpwire.app/

## Security Note

- Always use strong passwords
- Keep your PIN secure
- Regularly update your system
- Monitor remote access sessions

## Contributing

Feel free to submit issues and enhancement requests!
If you happen to run, modify scripts for other distros, please submit pr and mr.
