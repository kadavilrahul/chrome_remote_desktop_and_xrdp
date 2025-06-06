# Remote Desktop Setup Script

Automated setup script that installs and configures XFCE desktop environment with xRDP server on Linux systems, including performance optimizations, network tuning, and security configurations. It inludes Firefox, Chromium, VS Code, Windsurf. It can be configured easily Microsoft RDP. The main advantage of this script is that it can run terminal commands as root while using Windsurf and VS Code. Tested and verified on Ubuntu 24.04.1 LTS.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/kadavilrahul/remote_desktop_xrdp.git
   ```

2. Navigate to the project directory:
   ```bash
   cd remote_desktop_xrdp
   ```

3. Run the setup script:
   ```bash
   bash setup_rdp.sh
   ```

## Configuration

The script automatically configures:
- XFCE as the default desktop environment
- xRDP server settings for optimal performance
- Network performance parameters
- Desktop effects and startup applications

### Custom Configuration
You can modify the following parameters in the script:
- RDP session quality (bitmap cache, color depth)
- Network optimization parameters
- Security settings
- Desktop environment preferences

## Usage

1. After installation, the RDP server will be running on port 3389
2. Connect to your system using any RDP client:
   - Windows: Use Remote Desktop Connection
   - Linux: Use Remmina or similar
   - macOS: Use Microsoft Remote Desktop

3. Enter your system's IP address and login credentials when prompted

## Troubleshooting

Common issues and solutions:

1. If connection fails:
   - Verify xRDP service is running: `systemctl status xrdp`
   - Check firewall settings: `sudo ufw status`
   - Ensure port 3389 is accessible

2. If performance is poor:
   - Adjust color depth in xRDP settings
   - Disable desktop effects
   - Check network connection quality

## Security Considerations

- The script configures basic security settings
- Consider additional measures:
  - Using SSH tunneling
  - Implementing firewall rules
  - Changing default RDP port
  - Enabling encryption

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

[Specify License]

## Maintainers

[Add maintainer information]

## Acknowledgments

- XFCE Desktop Environment
- xRDP Project
