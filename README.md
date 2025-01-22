# Chrome Remote Desktop Installer for Ubuntu

A shell script to automate the installation of XFCE desktop environment and Chrome Remote Desktop on Ubuntu servers, enabling graphical remote access from any device.

## Features

- Automated installation of XFCE desktop environment
- Chrome Remote Desktop setup
- Firefox browser installation
- Secure user creation with password protection
- Complete GUI access to your Ubuntu server

## Prerequisites

- Ubuntu Server (Tested on Ubuntu 24.04.1 LTS)
- Root access or sudo privileges
- Internet connection
- Chrome browser on your local machine

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kadavilrahul/chrome_remote_desktop.git
   cd chrome_remote_desktop
   ```

2. Run the installation script:
   ```bash
   bash install_chrome_remote_desktop.sh
   ```

3. Follow the interactive prompts:
   - Enter a username when prompted
   - Enter and confirm your password
   - Wait for the installation to complete

## Post-Installation Setup

1. Install the Chrome Remote Desktop extension in your Chrome browser
2. Navigate to Chrome Remote Desktop settings:
   - Go to "Setup via SSH"
   - Select "Set up another computer"
   - Click "Begin" > "Next" > "Authorize"
   - Choose "Debian Linux"
   - Copy the provided command

3. On your Ubuntu server:
   - Log in with your newly created user credentials
   - Paste and run the command copied from Chrome Remote Desktop
   - Set up a PIN when prompted
   - Complete the on-screen setup process

## Usage

1. Open Chrome Remote Desktop in your browser
2. Look for your server under "Remote Access"
3. Click to connect and enter your PIN
4. You now have full GUI access to your Ubuntu server

## Benefits

- Access your server's GUI from any device
- Fast and secure remote access
- Run graphical applications seamlessly
- Better alternative to traditional SSH for GUI needs
- High-speed connection for smooth operation

## Troubleshooting

If you encounter any issues:
1. Ensure all installation steps were completed successfully
2. Verify your user has proper permissions
3. Check your internet connection
4. Make sure Chrome Remote Desktop service is running

## Security Note

- Always use strong passwords
- Keep your PIN secure
- Regularly update your system
- Monitor remote access sessions

## Contributing

Feel free to submit issues and enhancement requests!
