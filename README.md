# Chrome Remote Desktop Setup

Automated installer for Chrome Remote Desktop and development tools across Linux distributions.

## 🚀 Quick Start

### Clone Repository
```bash
git clone https://github.com/yourusername/chrome_remote_desktop_and_xrdp.git
cd chrome_remote_desktop_and_xrdp
```

### Run Interactive Menu
```bash
sudo ./run.sh
```

### Direct Commands
```bash
# Install Chrome Remote Desktop
sudo ./run.sh 1

# Install Google Chrome
sudo ./run.sh 2

# Install VS Code
sudo ./run.sh 3

# Setup xRDP
sudo ./run.sh 4

# Update all tools
sudo ./run.sh 10

# Uninstall tools
sudo ./run.sh 11
```

## 📦 What Gets Installed

### Chrome Remote Desktop (Option 1)
- Chrome Remote Desktop service
- XFCE desktop environment
- LightDM display manager
- Firefox web browser
- User account creation

### Google Chrome (Option 2)
- Latest Google Chrome browser
- Auto-updates enabled

### Visual Studio Code (Option 3)
- VS Code editor
- Official Microsoft repository

### xRDP Setup (Option 4)
- xRDP service for Microsoft RDP
- XFCE desktop integration
- Performance optimizations

## 🐧 Supported Distributions

- ✅ **Ubuntu/Debian** (apt) - Fully tested
- ✅ **Fedora/RHEL** (dnf/yum) - Compatible
- ✅ **Arch Linux** (pacman) - Compatible
- ✅ **openSUSE** (zypper) - Compatible
- ✅ **Mageia** (urpmi) - Experimental
- ✅ **Gentoo** (emerge) - Experimental

## 🛠️ Development Workflow

```bash
# Clone and setup
git clone <repository-url>
cd chrome_remote_desktop_and_xrdp

# Make changes
nano run.sh  # Edit files

# Test changes
sudo ./run.sh

# Commit changes
git add .
git commit -m "Updated installation scripts"
git push origin main
```

## 📋 Menu Options

1. **Chrome Remote Desktop** - Complete remote desktop setup
2. **Google Chrome** - Install Chrome browser
3. **VS Code** - Install code editor
4. **xRDP Setup** - Microsoft RDP support
5-9. **Shell versions** - Alternative implementations
10. **Update All** - Update system and tools
11. **Uninstall All** - Remove all installed tools
12. **Uninstall Chrome RD** - Remove Chrome Remote Desktop only
13. **Install Go** - Install Go programming language

## 🔧 Troubleshooting

- **Permission denied**: Run with `sudo`
- **Go not found**: Use option 13 to install Go first
- **Package conflicts**: Run `sudo apt autoremove` then retry
- **Service not starting**: Check `systemctl status chrome-remote-desktop`

## 📁 Project Structure

```
├── run.sh                 # Main interactive menu
├── go/                    # Go implementation (recommended)
│   ├── *.go              # Source files
│   ├── build-all.sh      # Build script
│   └── install_go.sh     # Go installer
├── shell/                 # Shell scripts (legacy)
│   ├── apt.sh            # Debian/Ubuntu
│   ├── dnf.sh            # Fedora/RHEL
│   ├── pacman.sh         # Arch Linux
│   └── zypper.sh         # openSUSE
├── update.sh             # System updater
└── uninstall_tools.sh    # Complete uninstaller
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Make changes and test
4. Commit: `git commit -m "Add feature"`
5. Push: `git push origin feature-name`
6. Create Pull Request

## 📞 Support

- Create GitHub issue for bugs
- Check troubleshooting section first
- Test on supported distributions
