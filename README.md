# Chrome Remote Desktop Setup

Automated installer for Chrome Remote Desktop and development tools across Linux distributions.

## ⚠️ **IMPORTANT NOTICE**

**Google Chrome Remote Desktop is officially supported ONLY on Debian-based Linux distributions (Ubuntu, Debian, Linux Mint, etc.).**

- ✅ **Debian/Ubuntu**: Full official support
- ⚠️ **Other distributions** (Fedora, Arch, openSUSE, etc.): Limited or no support
- ✅ **Alternative**: Use **xRDP** (Option 4) for universal Linux RDP support

For non-Debian systems, consider using xRDP instead of Chrome Remote Desktop.

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
When prompted add new user and password for Linux

## 📦 What Gets Installed

### Chrome Remote Desktop
- Chrome Remote Desktop service
- XFCE desktop environment
- LightDM display manager
- Firefox web browser
- User account creation
- **Note:** Only works on Debian/Ubuntu systems

### Google Chrome
- Latest Google Chrome browser
- Auto-updates enabled
- Works on all Linux distributions

### Visual Studio Code
- VS Code editor
- Official Microsoft repository
- Works on all Linux distributions

### xRDP Setup
- xRDP service for Microsoft RDP
- XFCE desktop integration
- Performance optimizations
- **Universal:** Works on ALL Linux distributions

## 🐧 Supported Distributions

### Chrome Remote Desktop (Official Google Support)
- ✅ **Ubuntu/Debian** (apt/aptitude) - **Officially Supported** by Google
- ❌ **Other distributions** - Not supported by Google

### xRDP (Microsoft RDP) - Universal Solution
- ✅ **ALL Linux distributions** - Full support via xRDP
- ✅ **Cross-platform compatibility** - Works with Windows RDP clients
- ✅ **No Google restrictions** - Works everywhere

**Important:** Google Chrome Remote Desktop only works on Debian/Ubuntu. Use xRDP for all other distributions.

## 📋 Available Tools

**Installation Tools:**
- **Chrome Remote Desktop** - ✅ Debian/Ubuntu only (official Google support)
- **Google Chrome** - Install Chrome browser (all distros)
- **VS Code** - Install code editor (all distros)
- **xRDP Setup** - ✅ Universal Microsoft RDP (works on ALL distros)
- **Shell versions** - Alternative implementations
- **Build Go tools** - Compile Go binaries

**Maintenance Tools:**
- **Update all tools** - Update system and tools
- **Uninstall all tools** - Remove all installed tools
- **Uninstall Chrome RD** - Remove Chrome Remote Desktop only
- **Install Go** - Install Go programming language

## 🔧 Troubleshooting

- **Permission denied**: Run with `sudo`
- **Go not found**: Run `sudo ./run.sh` and select "Install Go"
- **Package conflicts**: Run `sudo apt autoremove` then retry
- **Service not starting**: Check `systemctl status chrome-remote-desktop`
- **Chrome RD not working**: Ensure you're on Debian/Ubuntu, use xRDP for other distros

## 📁 Project Structure

```
├── run.sh                 # Main interactive menu
├── go/                    # Go implementation (recommended)
│   ├── *.go              # Source files
│   ├── build-all.sh      # Build script
│   ├── install_go.sh     # Go installer
│   └── chrome-remote-desktop # Built binary
├── shell/                 # Shell scripts (legacy)
│   ├── apt.sh            # Debian/Ubuntu (Chrome RD)
│   ├── chrome.sh         # Google Chrome (all distros)
│   ├── vscode.sh         # VS Code (all distros)
│   ├── setup_rdp.sh      # xRDP (universal)
│   └── chrome_remote_desktop.sh # Auto-detect (Debian/Ubuntu only)
├── update.sh             # System updater
├── uninstall_tools.sh    # Complete uninstaller
├── uninstall_chrome_remote_desktop.sh # Chrome RD uninstaller
└── README.md             # This file
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
- For Chrome Remote Desktop: Use Debian/Ubuntu only
- For universal RDP: Use xRDP on any Linux distribution
- Test on supported distributions before reporting issues

This is a test line
