# Chrome Remote Desktop Setup

Automated installer for Chrome Remote Desktop and development tools across Linux distributions.

## 🚀 Quick Start

### Clone Repository

```bash
git clone https://github.com/kadavilrahul/chrome_remote_desktop_and_xrdp.git
```

```bash
cd chrome_remote_desktop_and_xrdp
```

```bash
bash run.sh
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


## 📋 Menu Options

**Installation Tools:**
- **Chrome Remote Desktop** - Complete remote desktop setup
- **Google Chrome** - Install Chrome browser
- **VS Code** - Install code editor
- **xRDP Setup** - Microsoft RDP support
- **Shell versions** - Alternative implementations
- **Build Go tools** - Compile Go binaries

**Maintenance Tools:**
- **Update all tools** - Update system and tools
- **Uninstall all tools** - Remove all installed tools
- **Uninstall Chrome RD** - Remove Chrome Remote Desktop only
- **Install Go** - Install Go programming language

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
